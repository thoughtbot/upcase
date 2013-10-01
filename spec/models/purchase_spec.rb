require 'spec_helper'

describe Purchase do
  context 'validations' do
    subject { described_class.new(purchaseable: create(:product)) }
    it { should belong_to(:user) }
    it { should validate_presence_of(:email) }
    it { should allow_value('chad-help@co.uk').for(:email) }
    it { should allow_value('chad-help@thoughtbot.com').for(:email) }
    it { should allow_value('chad.help@thoughtbot.com').for(:email) }
    it { should allow_value('chad@thoughtbot.com').for(:email) }
    it { should_not allow_value('chad').for(:email) }
    it { should_not allow_value('chad@blah').for(:email) }
    it { should_not validate_presence_of(:user_id) }

    it { should delegate(:subscription?).to(:purchaseable) }
  end

  it 'produces the paid price when possible' do
    purchase = create(:purchase, paid_price: 200)
    purchase.price.should eq 200
  end

  describe 'self.paid' do
    it 'returns paid purchases' do
      paid = create(:purchase)
      unpaid = create(:unpaid_purchase)
      Purchase.paid.should == [paid]
    end
  end

  describe 'self.within_range' do
    it 'returns paid purchases from the given period' do
      outside = create(:purchase, created_at: 40.days.ago)
      unpaid = create(:unpaid_purchase, created_at: 7.days.ago)
      inside = create(:purchase, created_at: 7.days.ago)

      purchases = Purchase.within_range(30.days.ago, Date.yesterday)
      expect(purchases).to include inside
      expect(purchases).not_to include outside
      expect(purchases).not_to include unpaid
    end
  end

  describe 'self.total_sales_within_range' do
    it 'returns the sum of the paid purchases from the given period' do
      product = create(:product, individual_price: 10)
      outside = create(:purchase, created_at: 40.days.ago, purchaseable: product)
      unpaid = create(:unpaid_purchase, created_at: 7.days.ago, purchaseable: product)
      create(:purchase, created_at: 7.days.ago, purchaseable: product)
      create(:purchase, created_at: 7.days.ago, purchaseable: product)

      total = Purchase.total_sales_within_range(30.days.ago, Date.yesterday)
      expect(total).to eq 20
    end
  end

  context '#status' do
    it 'returns in-progress when it can purchaseable online and ends in future' do
      section = create(:online_section, ends_on: 2.days.from_now)
      purchase = create_subscriber_purchase_from_purchaseable(section)

      expect(purchase.status).to eq 'in-progress'
    end

    it 'returns registered when it ends in future' do
      section = create(:section, ends_on: 5.days.since)
      purchase = create_subscriber_purchase_from_purchaseable(section)

      expect(purchase.status).to eq 'registered'
    end

    it 'returns complete when already end' do
       section = create(:section, ends_on: 5.days.ago)
      purchase = create_subscriber_purchase_from_purchaseable(section)

      expect(purchase.status).to eq 'complete'
    end
  end

  context '#set_as_paid' do
    it 'sets paid properties' do
      purchase = build(:unpaid_purchase)

      purchase.set_as_paid

      purchase.paid.should be_true
      purchase.paid_price.should eq purchase.price
    end

    it 'applies a coupon' do
      coupon = create(:coupon)
      coupon.stubs(:applied)
      purchase = build(:unpaid_purchase, coupon: coupon)

      purchase.set_as_paid

      coupon.should have_received(:applied)
    end
  end

  context "#set_as_unpaid" do
    it 'becomes unpaid' do
      purchase = build_stubbed(:paid_purchase)

      purchase.set_as_unpaid

      purchase.should_not be_paid
    end
  end

  context 'when not fulfilled_with_github' do
    it 'does not fulfill with github' do
      purchase = build(:paid_purchase)
      fulfillment = stub(:fulfill)
      GithubFulfillment.stubs(:new).returns(fulfillment)

      purchase.save!

      fulfillment.should have_received(:fulfill).never
    end
  end

  context 'when fulfilled_with_github' do
    it 'fulfills with github' do
      product = create(:github_book_product)
      purchase = build(:purchase, purchaseable: product)
      fulfillment = stub(:fulfill)
      GithubFulfillment.stubs(:new).returns(fulfillment)

      purchase.save!

      fulfillment.should have_received(:fulfill)
    end
  end

  it 'fulfills with mailchimp' do
    product = create(:book_product)
    purchase = build(:purchase, purchaseable: product)
    fulfillment = stub(:fulfill)
    MailchimpFulfillment.stubs(:new).returns(fulfillment)

    purchase.save!

    fulfillment.should have_received(:fulfill)
  end

  it 'uses its lookup for its param' do
    purchase = build(:purchase, lookup: 'findme')

    purchase.to_param.should eq 'findme'
  end

  it 'computes its final price off its product variant' do
    product = build_stubbed(:product, individual_price: 15, company_price: 50)
    individual_purchase =
      build_stubbed(:purchase, variant: 'individual', purchaseable: product)
    company_purchase =
      build_stubbed(:purchase, variant: 'company', purchaseable: product)

    individual_purchase.price.should eq 15
    company_purchase.price.should eq 50
  end

  it 'generates a lookup' do
    purchase = build(:purchase, lookup: nil)

    purchase.save!
    purchase.lookup.should_not be_nil
  end

  it 'uses its coupon in its charged price' do
    coupon = build_stubbed(:coupon, amount: 25)
    product = build_stubbed(:product, individual_price: 40)
    purchase = build_stubbed(
      :purchase,
      coupon: coupon,
      purchaseable: product,
      variant: 'individual'
    )

    purchase.price.should eq 30
  end
end

describe Purchase, 'with stripe and a bad card' do
  it "doesn't save" do
    payment = stub('payment', place: false)
    Payments::StripePayment.stubs(:new).returns(payment)
    product = build(:product, individual_price: 15, company_price: 50)
    purchase = build(:purchase, purchaseable: product, payment_method: 'stripe')
    purchase.save.should be_false
  end
end

describe Purchase, 'refund' do
  it 'sets the purchase as unpaid' do
    purchase = create(:paid_purchase)

    purchase.refund

    purchase.should_not be_paid
  end

  it 'does not issue a refund if it is unpaid' do
    payment = stub('payment', place: true)
    Payments::StripePayment.stubs(:new).returns(payment)
    purchase = create(:unpaid_purchase)

    purchase.refund

    payment.should have_received(:refund).never
    purchase.should_not be_paid
  end

  context 'when not fulfilled_with_github' do
    it 'does not remove from github' do
      purchase = create(:paid_purchase)
      fulfillment = stub(:remove)
      GithubFulfillment.stubs(:new).returns(fulfillment)

      purchase.refund

      fulfillment.should have_received(:remove).never
    end
  end

  context 'when fulfilled_with_github' do
    it 'removes from github' do
      product = create(:github_book_product)
      purchase = create(:paid_purchase, purchaseable: product)
      fulfillment = stub(:remove)
      GithubFulfillment.stubs(:new).returns(fulfillment)

      purchase.refund

      fulfillment.should have_received(:remove)
    end
  end

  it "removes the purchaser's email from lists" do
    product = create(:book_product)
    purchase = create(:paid_purchase, purchaseable: product)
    fulfillment = stub(:remove)
    MailchimpFulfillment.stubs(:new).returns(fulfillment)

    purchase.refund

    fulfillment.should have_received(:remove)
  end
end

describe Purchase, 'of a subscription' do
  it 'validates the presence of a user' do
    expect(build_plan_purchase).to validate_presence_of(:user_id)
  end

  def build_plan_purchase
    build(
      :plan_purchase,
      purchaseable: create(:plan),
      payment_method: 'stripe'
    )
  end
end

describe Purchase, 'being paid' do
  it 'sends a receipt' do
    purchase = create(:unpaid_purchase)
    purchase.paid = true
    SendPurchaseReceiptEmailJob.stubs(:enqueue)

    purchase.save!

    SendPurchaseReceiptEmailJob.should have_received(:enqueue).with(purchase.id)
  end

  it 'uses a one-time coupon' do
    coupon = create(:one_time_coupon, amount: 25)
    first_purchase = create(:purchase, coupon: coupon, paid: true)
    first_purchase.price.should eq 11.25

    second_purchase = create(:purchase, coupon: coupon.reload)

    second_purchase.price.should eq 15.00
  end
end

describe Purchase, 'with stripe' do
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, purchaseable: product, payment_method: 'stripe') }
  let(:payment) { stub('payment', :refund => true, :update_user => true, place: true) }
  subject { purchase }

  before do
    Payments::StripePayment.stubs(:new).returns(payment)
  end

  it 'calculates its price and paid price using the subscription coupon when there is a stripe coupon' do
    subscription_coupon = stub(apply: 20)
    SubscriptionCoupon.stubs(:new).returns(subscription_coupon)
    purchase = create(:plan_purchase, stripe_coupon_id: '25OFF')

    expect(purchase.price).to eq 20
  end

  it 'is still a stripe purchase if its coupon discounts 100%' do
    subscription_coupon = stub(apply: 0)
    SubscriptionCoupon.stubs(:new).returns(subscription_coupon)
    purchase = create(:plan_purchase, stripe_coupon_id: 'FREEMONTH')

    expect(purchase).to be_stripe
  end

  it 'refunds money to purchaser' do
    purchase = build(:paid_purchase, payment_method: 'stripe')
    payment = stub('payment', refund: true, place: true)
    Payments::StripePayment.stubs(:new).with(purchase).returns(payment)

    purchase.refund

    payment.should have_received(:refund)
  end
end

describe Purchase, 'with paypal' do
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:payment) { stub('payment', place: true, refund: true, complete: true) }

  subject { build(:purchase, purchaseable: product, payment_method: 'paypal') }

  before do
    Payments::PaypalPayment.stubs(:new).with(subject).returns(payment)
    subject.save!
  end

  it 'starts a paypal transaction' do
    payment.should have_received(:place)
    subject.reload.should_not be_paid
  end

  it 'completes a transaction' do
    params = { token: 'TOKEN' }
    subject.complete_payment(params)

    payment.
      should have_received(:complete).with(params)
  end

  context 'and refunded' do
    it 'refunds money to purchaser' do
      subject.payment_transaction_id = 'TRANSACTION-ID'
      subject.paid = true
      subject.save!

      subject.refund

      payment.should have_received(:refund)
      subject.reload.paid.should be_false
    end
  end
end

describe Purchase, 'with no price' do
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
  context 'with github_usernames' do
    it 'saves the first github_username to the user' do
      user = create(:user)
      user.github_username.should be_blank
      purchase = create(:purchase, user: user, github_usernames: ['tbot', 'other'])
      user.reload.github_username.should == 'tbot'
    end

    it "doesn't overwrite first github_username to the user" do
      user = create(:user, github_username: 'test')
      purchase = create(:purchase, user: user, github_usernames: ['tbot', 'other'])
      user.reload.github_username.should == 'test'
    end
  end

  context 'with address information' do
    it 'saves the address to the user' do
      user = create(:user)
      user.address1.should be_blank

      purchase = create(
        :purchase,
        user: user,
        organization: 'thoughtbot',
        address1: '41 Winter St.',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )
      user.reload

      user.organization.should eq 'thoughtbot'
      user.address1.should eq '41 Winter St.'
      user.address2.should eq 'Floor 7'
      user.city.should eq 'Boston'
      user.state.should eq 'MA'
      user.zip_code.should eq '02108'
      user.country.should eq 'USA'
    end

    it "doesn't overwite the organization with blank" do
      user = create(:user, organization: 'thoughtbot')

      purchase = create(
        :purchase,
        user: user,
        organization: ''
      )
      user.reload

      user.organization.should eq 'thoughtbot'
    end

    it 'overwrites the address if provided' do
      user = create(:user, address1: 'testing')

      purchase = create(
        :purchase,
        user: user,
        organization: 'thoughtbot',
        address1: '41 Winter St.',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )
      user.reload

      user.address1.should eq '41 Winter St.'
      user.address2.should eq 'Floor 7'
      user.city.should eq 'Boston'
      user.state.should eq 'MA'
      user.zip_code.should eq '02108'
      user.country.should eq 'USA'
    end

    it "doesn't overwrite the address if not provided" do
      user = create(:user, address1: 'testing')

      purchase = create(
        :purchase,
        user: user,
        address1: '',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )
      user.reload

      user.address1.should eq 'testing'
      user.address2.should be_blank
      user.city.should be_blank
      user.state.should be_blank
      user.zip_code.should be_blank
      user.country.should be_blank
    end
  end
end

describe Purchase, 'given a purchaser' do
  let(:purchaser) do
    create(
      :user,
      github_username: 'Hello',
      organization: 'thoughtbot',
      address1: '41 Winter St.',
      address2: 'Floor 7',
      city: 'Boston',
      state: 'MA',
      zip_code: '02108',
      country: 'USA'
    )
  end

  it 'populates default info when given a purchaser' do
    product = create(:product, fulfillment_method: 'other')
    purchase = product.purchases.build
    purchase.defaults_from_user(purchaser)

    purchase.name.should == purchaser.name
    purchase.email.should == purchaser.email
    purchase.github_usernames.try(:first).should be_blank
    purchase.organization.should eq 'thoughtbot'
    purchase.address1.should eq '41 Winter St.'
    purchase.address2.should eq 'Floor 7'
    purchase.city.should eq 'Boston'
    purchase.state.should eq 'MA'
    purchase.zip_code.should eq '02108'
    purchase.country.should eq 'USA'
  end

  context 'for a product fulfilled through github' do
    it 'populates default info including first github_username' do
      product = create(:github_book_product)
      purchase = product.purchases.build
      purchase.defaults_from_user(purchaser)

      purchase.name.should == purchaser.name
      purchase.email.should == purchaser.email
      purchase.github_usernames.first.should == purchaser.github_username
    end
  end

  context 'for a subscription plan' do
    it 'populates default info including first github_username' do
      plan = create(:plan)
      purchase = plan.purchases.build
      purchase.defaults_from_user(purchaser)

      purchase.name.should == purchaser.name
      purchase.email.should == purchaser.email
      purchase.github_usernames.first.should == purchaser.github_username
    end

    it 'requires a password if there is no user' do
      plan = create(:plan)
      purchase = build(:purchase, purchaseable: plan, user: nil)
      purchase.password = ''

      purchase.save

      expect(purchase.errors[:password]).to include "can't be blank"
    end

    it 'creates a user when saved with a password' do
      create_mentors
      plan = create(:plan)
      purchase = build(
        :purchase,
        purchaseable: plan,
        user: nil,
        github_usernames: ['cpytel']
      )
      purchase.password = 'test'

      purchase.save!

      expect(purchase.user).to be_persisted
    end
  end
end

describe Purchase, 'starts_on' do
  it "gets the starts_on from it's purchaseable and it's own created_at" do
    created_at = 1.day.ago
    product = build(:product)
    product.stubs(:starts_on)
    purchase = build(:purchase, purchaseable: product, created_at: created_at)

    purchase.starts_on

    expect(product).to have_received(:starts_on).with(created_at.to_date)
  end
end

describe Purchase, 'ends_on' do
  it "gets the starts_on from it's purchaseable and it's own created_at" do
    created_at = 1.day.ago
    product = build(:product)
    product.stubs(:ends_on)
    purchase = build(:purchase, purchaseable: product, created_at: created_at)

    purchase.ends_on

    expect(product).to have_received(:ends_on).with(created_at.to_date)
  end
end

describe Purchase, 'active?' do
  it "is true when today is between start and end" do
    product = build(:product)
    product.stubs(starts_on: Date.yesterday, ends_on: 4.days.from_now.to_date)
    purchase = build(:purchase, purchaseable: product, created_at: Time.zone.today)

    Timecop.freeze(Time.zone.today) do
      expect(purchase).to be_active
    end

    Timecop.freeze(6.days.from_now) do
      expect(purchase).not_to be_active
    end
  end
end

describe Purchase, '.of_sections' do
  it 'returns no Purchases when none are Sections' do
    create(:book_purchase)
    expect(Purchase.of_sections).to be_empty
  end

  it 'returns Purchases for Sections' do
    purchase = create_subscriber_purchase(:section)
    expect(Purchase.of_sections).to eq [purchase]
  end
end

describe Purchase, 'date_of_last_workshop_purchase' do
  it 'returns the date of the most-recent workshop purchase' do
    expect(Purchase.date_of_last_workshop_purchase).to be_nil

    purchase = create_subscriber_purchase(:section)
    Timecop.travel(Date.yesterday) do
      create_subscriber_purchase(:section)
    end
    expect(Purchase.date_of_last_workshop_purchase).to eq Time.zone.today
  end
end

describe Purchase, 'within_30_days' do
  it 'returns Purchases made within the last 30 days' do
    Timecop.freeze Time.now do
      create(:purchase, created_at: 30.days.ago, name: 'within range')
      create(:purchase, created_at: (30.days + 1.second).ago, name: 'outside range')

      expect(Purchase.within_30_days.map(&:name)).to eq ['within range']
    end
  end
end
