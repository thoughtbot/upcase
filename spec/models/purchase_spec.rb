require 'spec_helper'

describe Purchase do
  it { should belong_to(:user) }
  it { should validate_presence_of(:email) }
  it { should allow_value('chad-help@co.uk').for(:email) }
  it { should allow_value('chad-help@thoughtbot.com').for(:email) }
  it { should allow_value('chad.help@thoughtbot.com').for(:email) }
  it { should allow_value('chad@thoughtbot.com').for(:email) }
  it { should_not allow_value('chad').for(:email) }
  it { should_not allow_value('chad@blah').for(:email) }
  it { should validate_presence_of(:billing_email) }

  it { should delegate(:subscription?).to(:purchaseable) }

  it 'can produce the host after setting it' do
    Purchase.host = 'hottiesandcreepers.com:123467'
    Purchase.host.should == 'hottiesandcreepers.com:123467'
  end

  it 'gives default host when host is not set' do
    Purchase.remove_class_variable('@@host')
    Purchase.host.should == ActionMailer::Base.default_url_options[:host]
  end

  it 'produces the paid price when possible' do
    purchase = create(:purchase, paid_price: 200)
    purchase.price.should be(200)
  end

  describe 'self.paid' do
    it 'returns paid purchases' do
      paid = create(:purchase, paid: true)
      unpaid = create(:purchase, paid: false)
      unpaid.update_column(:paid, false)
      Purchase.paid.should == [paid]
    end
  end
end

describe Purchase, 'with stripe and a bad card' do
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, purchaseable: product, payment_method: 'stripe') }
  let(:host) { ActionMailer::Base.default_url_options[:host] }
  subject { purchase }

  before do
    Stripe::Customer.stubs(:create).returns(stub(:id => 'stripe'))
    Stripe::Charge.stubs(:create).raises(Stripe::StripeError, 'Your card was declined')
  end

  it "doesn't throw an exception and adds an error message on save" do
    subject.save.should be_false
    subject.errors[:base].should include 'There was a problem processing your credit card, your card was declined'
  end
end

describe Purchase, 'refund' do
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, purchaseable: product, payment_method: '$') }
  subject { purchase }

  it 'sets the purchase as unpaid' do
    subject.refund
    subject.should_not be_paid
  end

  it 'does not issue a refund if it is unpaid' do
    subject.paid = false
    subject.stubs(:stripe_refund).returns(nil)
    subject.stubs(:paypal_refund).returns(nil)
    subject.refund

    subject.should have_received(:stripe_refund).never
    subject.should have_received(:paypal_refund).never
    subject.should_not be_paid
  end
end

describe Purchase, 'of a subscription' do
  it 'does not set payment_transaction_id' do
    build_subscription_purchase.save!
    expect(subject.payment_transaction_id).to be_nil
  end

  it 'updates the subscription on the Stripe customer with the correct plan' do
    customer = stub('<Stripe::Customer>', update_subscription: true)
    Stripe::Customer.stubs(:retrieve).returns(customer)
    purchase = build_subscription_purchase

    purchase.save!

    expect(customer).to have_received(:update_subscription).with(plan: purchase.purchaseable.sku, coupon: nil)
  end

  it 'updates the subscription with the given coupon' do
    customer = stub('<Stripe::Customer>', update_subscription: true)
    coupon = stub('<Stripe::Coupon>', amount_off: 25)
    Stripe::Customer.stubs(:retrieve).returns(customer)
    Stripe::Coupon.stubs(:retrieve).returns(coupon)
    purchase = build_subscription_purchase
    purchase.stripe_coupon_id = '25OFF'

    purchase.save!

    expect(customer).to have_received(:update_subscription).with(plan: Purchase::PLAN_NAME, coupon: '25OFF')
  end

  def build_subscription_purchase
    build(:purchase, purchaseable: create(:subscribeable_product), payment_method: 'stripe')
  end
end

describe Purchase, 'with stripe' do
  include Rails.application.routes.url_helpers
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, purchaseable: product, payment_method: 'stripe') }
  let(:host) { ActionMailer::Base.default_url_options[:host] }
  subject { purchase }

  before do
    Stripe::Customer.stubs(:create).returns(stub(:id => 'stripe'))
    Stripe::Charge.stubs(:create).returns(stub(:id => 'TRANSACTION-ID'))
  end

  it 'generates a lookup on save' do
    subject.lookup.should be_nil
    subject.save!
    subject.lookup.should_not be_nil
  end

  it 'sends a receipt on save' do
    SendPurchaseReceiptEmailJob.stubs(:enqueue)

    subject.save!

    SendPurchaseReceiptEmailJob.should have_received(:enqueue).with(subject.id)
  end

  it 'computes its final price off its product variant' do
    subject.variant = 'individual'
    subject.price.should == 15
    subject.variant = 'company'
    subject.price.should == 50

    subject.save!
    subject.paid_price.should == 50
  end

  it 'uses its coupon in its charged price' do
    subject.coupon = create(:coupon, amount: 25)
    subject.save!
    Stripe::Charge.should have_received(:create).with(amount: 1125, currency: 'usd', customer: 'stripe', description: product.name)
    Stripe::Charge.should have_received(:create).with(has_entries(amount: instance_of(Fixnum)))
  end

  it 'uses a one-time coupon' do
    coupon = create(:one_time_coupon, amount: 25)
    subject.coupon = coupon
    subject.save!
    Stripe::Charge.should have_received(:create).with(amount: 1125, currency: 'usd', customer: 'stripe', description: product.name)
    purchase = create(:stripe_purchase, purchaseable: product, coupon: coupon.reload)
    Stripe::Charge.should have_received(:create).with(amount: 1500, currency: 'usd', customer: 'stripe', description: product.name)
  end

  it 'calculates its price and paid price using the subscription coupon when there is a stripe coupon' do
    subscription_coupon = stub(apply: 20)
    SubscriptionCoupon.stubs(:new).returns(subscription_coupon)
    purchase = create(:subscription_purchase, stripe_coupon_id: '25OFF')

    expect(purchase.price).to eq 20
    expect(purchase.paid_price).to eq 20
  end

  context 'saved' do
    before do
      subject.save!
    end

    it 'uses its lookup for its param' do
      subject.lookup.should == subject.to_param
    end

    it 'saves the transaction id on save' do
      subject.payment_transaction_id.should ==  'TRANSACTION-ID'
    end

    it 'sets the stripe customer on save' do
      subject.stripe_customer.should == 'stripe'
    end

    context 'and refunded' do
      let(:charge) { stub(:id => 'TRANSACTION-ID', :refunded => false) }
      let(:refunded_charge) { stub(:id => 'TRANSACTION-ID', :refunded => true) }
      let(:client) { stub(remove_team_member: nil) }

      before do
        charge.stubs(:refund).returns(refunded_charge)
        Stripe::Charge.stubs(:retrieve).returns(charge)
      end

      it 'refunds money to purchaser' do
        subject.stripe_refund
        Stripe::Charge.should have_received(:retrieve).with('TRANSACTION-ID')
        charge.should have_received(:refund).with(amount: 1500)
      end
    end
  end

  context 'when the product is fulfilled by github' do
    let(:client) { stub(add_team_member: nil) }

    before do
      product.fulfillment_method = 'github'
      product.github_team = 73110
      product.save!
      Octokit::Client.stubs(new: client)
    end

    it "doesn't add any users to github when there are blank usernames" do
      purchase = product.purchases.build(
        variant: 'individual',
        name: 'test',
        email: 'joe@example.com',
        readers: ['', ''],
        payment_method: 'stripe'
      )
      purchase.save!

      client.should have_received(:add_team_member).never
    end

    it 'adds any users to github when it is a backbone book sale' do
      purchase = product.purchases.build(
        variant: 'individual',
        name: 'test',
        email: 'joe@example.com',
        readers: ['cpytel'],
        payment_method: 'stripe'
      )
      purchase.save!

      client.should have_received(:add_team_member).with(73110, 'cpytel')
    end

    it 'adds multiple users to github when it is a backbone book sale' do
      purchase = product.purchases.build(
        variant: 'individual',
        name: 'test',
        email: 'joe@example.com',
        readers: ['cpytel', 'reader2'],
        payment_method: 'stripe'
      )
      purchase.save!

      client.should have_received(:add_team_member).with(73110, 'cpytel')
      client.should have_received(:add_team_member).with(73110, 'reader2')
    end

    it 'notifies Airbrake when username not found' do
      Airbrake.stubs(:notify)
      client = stub()
      client.stubs(:add_team_member).raises(Octokit::NotFound)
      Octokit::Client.stubs(new: client)
      purchase = product.purchases.build(
        variant: 'individual',
        name: 'test',
        email: 'joe@example.com',
        readers: ['cpytel'],
        payment_method: 'stripe'
      )
      purchase.save!

      Airbrake.should have_received(:notify).once
    end

    it 'notifies Airbrake when Net::HTTPBadResponse' do
      Airbrake.stubs(:notify)
      client = stub()
      client.stubs(:add_team_member).raises(Net::HTTPBadResponse)
      Octokit::Client.stubs(new: client)
      purchase = product.purchases.build(
        variant: 'individual',
        name: 'test',
        email: 'joe@example.com',
        readers: ['cpytel'],
        payment_method: 'stripe'
      )
      purchase.save!

      Airbrake.should have_received(:notify).once
    end

    it 'notifies the user when adding to repository fails' do
      Mailer.stubs(fulfillment_error: stub(deliver: true))
      client = stub
      client.stubs(:add_team_member).raises(Octokit::NotFound)
      Octokit::Client.stubs(new: client)
      purchase = product.purchases.build(
        variant: 'individual',
        name: 'test',
        email: 'joe@example.com',
        readers: ['cpytel'],
        payment_method: 'stripe'
      )
      purchase.save!

      Mailer.should have_received(:fulfillment_error).with(purchase, 'cpytel')
    end

    context 'and removing team members' do
      it 'removes user from github team' do
        client.stubs(:remove_team_member).returns(nil)
        subject.readers = ['jayroh', 'cpytel']
        subject.save!
        subject.remove_readers_from_github

        client.should have_received(:remove_team_member).with(73110, 'cpytel')
        client.should have_received(:remove_team_member).with(73110, 'jayroh')
      end

      it 'notifies hoptoad/airbrake when user is not found' do
        client.stubs(:remove_team_member).raises(Octokit::NotFound)
        Octokit::Client.stubs(new: client)
        Airbrake.stubs(:notify)
        subject.readers = ['nonsense']
        subject.save!
        subject.remove_readers_from_github

        Airbrake.should have_received(:notify).once
      end
    end
  end
end

describe Purchase, 'with paypal' do
  include Rails.application.routes.url_helpers

  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:paypal_request) { stub( setup: stub(redirect_uri: 'http://paypalurl'),
    checkout!: stub( payment_info: [ stub(transaction_id: 'TRANSACTION-ID' )]),
    refund!: nil) }
  let(:paypal_payment_request) { stub }

  subject { build(:purchase, purchaseable: product, payment_method: 'paypal') }

  before do
    Paypal::Express::Request.stubs(:new => paypal_request)
    Paypal::Payment::Request.stubs(:new => paypal_payment_request)
    subject.save!
  end

  it 'starts a paypal transaction' do
    Paypal::Payment::Request.should have_received(:new).with(currency_code: :USD, amount: subject.price, description: subject.purchaseable_name, items: [{ amount: subject.price, description: subject.purchaseable_name }])
    paypal_request.should have_received(:setup).with(paypal_payment_request, paypal_purchase_url(subject, host: ActionMailer::Base.default_url_options[:host]), products_url(host: ActionMailer::Base.default_url_options[:host]))
    subject.paypal_url.should == 'http://paypalurl'
    subject.should_not be_paid
  end

  context 'after completing a paypal payment' do
    before do
      subject.complete_paypal_payment!('TOKEN', 'PAYERID')
    end

    it 'marks an order as paid' do
      subject.should be_paid
    end

    it 'saves a transaction id' do
      subject.payment_transaction_id.should == 'TRANSACTION-ID'
    end
  end

  context 'and refunded' do
    subject do
      build(:purchase,
            purchaseable: product,
            payment_method: 'paypal',
            payment_transaction_id: 'TRANSACTION-ID')
    end

    it 'refunds money to purchaser' do
      subject.paypal_refund
      paypal_request.should have_received(:refund!).with('TRANSACTION-ID')
      subject.reload.paid.should be_false
    end
  end
end

describe Purchase, 'with no price' do
  include Rails.application.routes.url_helpers
  let(:host) { ActionMailer::Base.default_url_options[:host] }

  context 'a valid purchase' do
    let(:product) { create(:product, individual_price: 0) }
    let(:purchase) do
      create(:individual_purchase, purchaseable: product)
    end

    subject { purchase }

    it { should be_free }
    it { should be_paid }
    its(:payment_method) { should == 'free' }
  end

  context 'a purchase with an invalid payment method' do
    let(:product) { create(:product, individual_price: 1000) }
    let(:purchase) { build(:purchase, purchaseable: product, payment_method: 'free') }
    subject { purchase }
    it { should_not be_valid }
  end
end

describe 'Purchases with various payment methods' do
  before do
    @stripe = create(:purchase, payment_method: 'stripe')
    @paypal = create(:purchase, payment_method: 'paypal')
  end

  it 'includes only stripe payments in the stripe finder' do
    Purchase.stripe.should == [@stripe]
  end
end

describe 'Purchases for various emails' do
  context '#by_email' do
    let(:email) { 'user@example.com' }

    before do
      @prev_purchases = [create(:purchase, email: email),
                         create(:purchase, email: email)]
      @other_purchase = create(:purchase)
    end

    it '#by_email' do
      Purchase.by_email(email).should =~ @prev_purchases
      Purchase.by_email(email).should_not include @other_purchase
    end
  end
end

describe Purchase, 'for a user' do
  context 'with readers' do
    it 'saves the first reader to the user' do
      user = create(:user)
      user.github_username.should be_blank
      purchase = create(:purchase, user: user, readers: ['tbot', 'other'])
      user.reload.github_username.should == 'tbot'
    end

    it "doesn't overwrite first reader to the user" do
      user = create(:user, github_username: 'test')
      purchase = create(:purchase, user: user, readers: ['tbot', 'other'])
      user.reload.github_username.should == 'test'
    end
  end
end

describe Purchase, 'given a purchaser' do
  let(:purchaser) { create(:user, github_username: 'Hello') }

  it 'populates default info when given a purchaser' do
    product = create(:product, fulfillment_method: 'other')
    purchase = product.purchases.build
    purchase.defaults_from_user(purchaser)

    purchase.name.should == purchaser.name
    purchase.email.should == purchaser.email
    purchase.readers.try(:first).should be_blank
  end

  context 'for a product fulfilled through github' do
    it 'populates default info including first reader' do
      product = create(:product, fulfillment_method: 'github')
      purchase = product.purchases.build
      purchase.defaults_from_user(purchaser)

      purchase.name.should == purchaser.name
      purchase.email.should == purchaser.email
      purchase.readers.first.should == purchaser.github_username
    end
  end

  context 'for a subscription product' do
    it 'populates default info including first reader' do
      product = create(:product, fulfillment_method: 'other', product_type: 'subscription')
      purchase = product.purchases.build
      purchase.defaults_from_user(purchaser)

      purchase.name.should == purchaser.name
      purchase.email.should == purchaser.email
      purchase.readers.first.should == purchaser.github_username
    end
  end
end
