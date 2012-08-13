require 'spec_helper'

describe Purchase do
  it { should belong_to(:user) }

  it 'can produce the host after setting it' do
    Purchase.host = 'hottiesandcreepers.com:123467'
    Purchase.host.should == 'hottiesandcreepers.com:123467'
  end

  it 'gives default host when host is not set' do
    Purchase.remove_class_variable('@@host')
    Purchase.host.should == ActionMailer::Base.default_url_options[:host]
  end
end

describe Purchase, "with stripe and a bad card" do
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, product: product, payment_method: "stripe") }
  let(:host) { ActionMailer::Base.default_url_options[:host] }
  subject { purchase }

  before do
    Stripe::Customer.stubs(:create).returns(stub(:id => "stripe"))
    Stripe::Charge.stubs(:create).raises(Stripe::StripeError, "Your card was declined")
  end

  it "doesn't throw an exception and adds an error message on save" do
    subject.save.should be_false
    subject.errors[:base].should include "There was a problem processing your credit card, your card was declined"
  end
end

describe Purchase, "with stripe" do
  include Rails.application.routes.url_helpers
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, product: product, payment_method: "stripe") }
  let(:host) { ActionMailer::Base.default_url_options[:host] }
  subject { purchase }

  before do
    Stripe::Customer.stubs(:create).returns(stub(:id => "stripe"))
    Stripe::Charge.stubs(:create).returns(stub(:id => "TRANSACTION-ID"))
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

  it "rescues Net::SMTPAuthenticationError on sending a receipt" do
    Airbrake.stubs(:notify)
    Mailer.stubs(:purchase_receipt).raises(Net::SMTPAuthenticationError)
    subject.save!
    Airbrake.should have_received(:notify)
  end

  it "rescues Net::SMTPFatalError on sending a receipt" do
    Airbrake.stubs(:notify)
    Mailer.stubs(:purchase_receipt).raises(Net::SMTPFatalError)
    subject.save!
    Airbrake.should have_received(:notify)
  end

  it "computes its final price off its product variant" do
    subject.variant = "individual"
    subject.price.should == 15
    subject.variant = "company"
    subject.price.should == 50
  end

  it "uses its coupon in its charged price" do
    subject.coupon = create(:coupon, amount: 25)
    subject.save!
    Stripe::Charge.should have_received(:create).with(amount: 1125, currency: "usd", customer: "stripe", description: product.name)
  end

  it "uses a one-time coupon" do
    coupon = create(:one_time_coupon, amount: 25)
    subject.coupon = coupon
    subject.save!
    Stripe::Charge.should have_received(:create).with(amount: 1125, currency: "usd", customer: "stripe", description: product.name)
    purchase = create(:stripe_purchase, product: product, coupon: coupon.reload)
    Stripe::Charge.should have_received(:create).with(amount: 1500, currency: "usd", customer: "stripe", description: product.name)
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

  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:paypal_request) { stub(setup: stub(redirect_uri: "http://paypalurl"),
                              checkout!: stub(payment_info: [stub(transaction_id: "TRANSACTION-ID")])) }
  let(:paypal_payment_request) { stub }

  subject { build(:purchase, product: product, payment_method: "paypal") }

  before do
    Paypal::Express::Request.stubs(:new => paypal_request)
    Paypal::Payment::Request.stubs(:new => paypal_payment_request)
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

describe "Purchases with various payment methods" do
  before do
    @stripe = create(:purchase, payment_method: "stripe")
    @paypal = create(:purchase, payment_method: "paypal")
  end

  it "includes only stripe payments in the stripe finder" do
    Purchase.stripe.should == [@stripe]
  end
end

describe "Purchases for various emails" do
  context "#by_email" do
    let(:email) { "user@example.com" }

    before do
      @prev_purchases = [create(:purchase, email: email),
                         create(:purchase, email: email)]
      @other_purchase = create(:purchase)
    end

    it "#by_email" do
      Purchase.by_email(email).should =~ @prev_purchases
      Purchase.by_email(email).should_not include @other_purchase
    end
  end
end

describe Purchase, "for a user" do
  context "with readers" do
    it "saves the first reader to the user" do
      user = create(:user)
      user.github_username.should be_blank
      purchase = create(:purchase, user: user, readers: ["tbot", "other"])
      user.reload.github_username.should == "tbot"
    end
  end
end
