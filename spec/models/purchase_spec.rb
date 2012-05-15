require 'spec_helper'

describe Purchase do
  it 'can produce the host after setting it' do
    Purchase.host = 'hottiesandcreepers.com:123467'
    Purchase.host.should == 'hottiesandcreepers.com:123467'
  end

  it 'gives default host when host is not set' do
    Purchase.remove_class_variable('@@host')
    Purchase.host.should == ActionMailer::Base.default_url_options[:host]
  end
end

describe Purchase, "with stripe" do
  include Rails.application.routes.url_helpers
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, product: product, payment_method: "stripe") }
  let(:host) { ActionMailer::Base.default_url_options[:host] }
  subject { purchase }

  before do
    Stripe::Customer.stubs(:create).returns(stub(id: "stripe"))
    Stripe::Charge.stubs(:create).returns(stub(id: "TRANSACTION-ID"))
    FetchAPI::Order.stubs(:create)
    FetchAPI::Base.stubs(:basic_auth)
    FetchAPI::Order.stubs(:find).returns(stub(link_full: "http://fetchurl"))
  end

  it "generates a lookup on save" do
    subject.lookup.should be_nil
    subject.save!
    subject.lookup.should_not be_nil
  end

  it "sends a receipt on save" do
    Mailer.stubs(purchase_receipt: stub(deliver: true))
    subject.save!
    Mailer.should have_received(:purchase_receipt).with(subject)
  end

  it "computes its final price off its product variant" do
    subject.variant = "individual"
    subject.price.should == 15
    subject.variant = "company"
    subject.price.should == 50
  end

  it "uses its coupon in its charged price" do
    subject.coupon = Factory(:coupon, amount: 25)
    subject.save!
    Stripe::Charge.should have_received(:create).with(amount: 1125, currency: "usd", customer: "stripe", description: product.name)
  end

  context 'saved' do
    before do
      subject.save!
    end

    it "uses its lookup for its param" do
      subject.lookup.should == subject.to_param
    end

    it "saves the transaction id on save" do
      subject.payment_transaction_id.should ==  "TRANSACTION-ID"
    end

    it 'sets the stripe customer on save' do
      subject.stripe_customer.should == "stripe"
    end

    its(:success_url) { should == product_purchase_path(product, purchase, host: host) }
  end

  context "when the product is fulfilled by fetch" do
    before do
      product.fulfillment_method = "fetch"
      product.save!
      subject.save!
      subject.should be_paid
    end

    it "fulfills the order through fetch" do
      FetchAPI::Base.should have_received(:basic_auth).with(FETCH_DOMAIN, FETCH_USERNAME, FETCH_PASSWORD).at_least_once
      FetchAPI::Order.should have_received(:create).with(id: subject.id, title: subject.product.name, first_name: subject.first_name, last_name: subject.last_name, email: subject.email, order_items: [{sku: subject.product.sku}])
    end
  end

  context "when the product is fulfilled by github" do
    let(:client) { stub(add_team_member: nil) }

    before do
      product.fulfillment_method = "github"
      product.github_team = 73110
      product.save!
      Octokit::Client.stubs(new: client)
    end

    it "doesn't add any users to github when there are blank usernames" do
      purchase = product.purchases.build(variant: "individual", name: "test", email: "joe@example.com", readers: ["", ""], payment_method: "stripe")
      purchase.save!
      client.should have_received(:add_team_member).never
    end

    it "adds any users to github when it is a backbone book sale" do
      purchase = product.purchases.build(variant: "individual", name: "test", email: "joe@example.com", readers: ["cpytel"], payment_method: "stripe")
      purchase.save!
      client.should have_received(:add_team_member).with(73110, "cpytel")
    end

    it "adds multiple users to github when it is a backbone book sale" do
      purchase = product.purchases.build(variant: "individual", name: "test", email: "joe@example.com", readers: ["cpytel", "reader2"], payment_method: "stripe")
      purchase.save!
      client.should have_received(:add_team_member).with(73110, "cpytel")
      client.should have_received(:add_team_member).with(73110, "reader2")
    end

    it "notify hoptoad when username not found" do
      Airbrake.stubs(:notify)
      client = stub()
      client.stubs(:add_team_member).raises(Octokit::NotFound)
      Octokit::Client.stubs(new: client)
      purchase = product.purchases.build(variant: "individual", name: "test", email: "joe@example.com", readers: ["cpytel"], payment_method: "stripe")
      purchase.save!
      Airbrake.should have_received(:notify).once
    end

    it "notifies Airbrake when Net::HTTPBadResponse" do
      Airbrake.stubs(:notify)
      client = stub()
      client.stubs(:add_team_member).raises(Net::HTTPBadResponse)
      Octokit::Client.stubs(new: client)
      purchase = product.purchases.build(variant: "individual", name: "test", email: "joe@example.com", readers: ["cpytel"], payment_method: "stripe")
      purchase.save!
      Airbrake.should have_received(:notify).once
    end
  end
end

describe Purchase, "with paypal" do
  include Rails.application.routes.url_helpers

  let(:product) { Factory(:product, individual_price: 15, company_price: 50) }
  let(:paypal_request) { stub(setup: stub(redirect_uri: "http://paypalurl"),
                              checkout!: stub(payment_info: [stub(transaction_id: "TRANSACTION-ID")])) }
  let(:paypal_payment_request) { stub }

  subject { Factory.build(:purchase, product: product, payment_method: "paypal") }

  before do
    Paypal::Express::Request.stubs(new: paypal_request)
    Paypal::Payment::Request.stubs(new: paypal_payment_request)
    FetchAPI::Order.stubs(:create)
    FetchAPI::Base.stubs(:basic_auth)
    FetchAPI::Order.stubs(:find).returns(stub(link_full: "http://fetchurl"))
    subject.save!
  end

  it "starts a paypal transaction" do
    Paypal::Payment::Request.should have_received(:new).with(currency_code: :USD, amount: subject.price, description: subject.product_name, items: [{ amount: subject.price, description: subject.product_name }])
    paypal_request.should have_received(:setup).with(paypal_payment_request, paypal_product_purchase_url(subject.product, subject, host: ActionMailer::Base.default_url_options[:host]), courses_url(host: ActionMailer::Base.default_url_options[:host]))
    subject.paypal_url.should == "http://paypalurl"
    subject.should_not be_paid
  end

  context "after completing a paypal payment" do
    before do
      subject.complete_paypal_payment!("TOKEN", "PAYERID")
    end

    it "marks an order as paid" do
      subject.should be_paid
    end

    it "saves a transaction id" do
      subject.payment_transaction_id.should == "TRANSACTION-ID"
    end
  end

  its(:success_url) { should == 'http://paypalurl' }
end

describe Purchase, 'with no price' do
  include Rails.application.routes.url_helpers
  let(:host) { ActionMailer::Base.default_url_options[:host] }

  context "a valid purchase" do
    let(:product) { create(:product, individual_price: 0) }
    let(:purchase) do
      FetchAPI::Order.stubs(:create)
      FetchAPI::Base.stubs(:basic_auth)
      FetchAPI::Order.stubs(:find).returns(stub(link_full: "http://fetchurl"))
      create(:individual_purchase, product: product)
    end

    subject { purchase }

    it { should be_free }
    it { should be_paid }
    its(:payment_method) { should == 'free' }
    its(:success_url) { should == product_purchase_path(product, purchase, host: host) }
  end

  context "a purchase with an invalid payment method" do
    let(:product) { create(:product, individual_price: 1000) }
    let(:purchase) { build(:purchase, product: product, payment_method: "free") }
    subject { purchase }
    it { should_not be_valid }
  end
end
