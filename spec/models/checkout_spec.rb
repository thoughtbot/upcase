require 'spec_helper'

describe Checkout do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:quantity) }

  it { should delegate(:user_email).to(:user).as(:email) }
  it { should delegate(:user_first_name).to(:user).as(:first_name) }
  it { should delegate(:user_last_name).to(:user).as(:last_name) }
  it { should delegate(:user_github_username).to(:user).as(:github_username) }

  context "#save" do
    it "fulfills a subscription when purchasing a plan" do
      purchase = build(:plan_purchase)
      fulfillment = stub_subscription_fulfillment(purchase)

      purchase.save!

      fulfillment.should have_received(:fulfill)
    end
  end
end

describe Checkout, "with stripe and a bad card" do
  it "doesn't save" do
    payment = stub("payment", place: false)
    Payments::StripePayment.stubs(:new).returns(payment)
    product = build(:product, individual_price: 15, company_price: 50)
    purchase = build(:purchase, purchaseable: product, payment_method: 'stripe')
    purchase.save.should be_false
  end
end

describe Checkout, 'being paid' do
  it 'sends a receipt' do
    purchase = create(:unpaid_purchase)
    purchase.paid = true
    SendCheckoutReceiptEmailJob.stubs(:enqueue)

    purchase.save!

    SendCheckoutReceiptEmailJob.should have_received(:enqueue).with(purchase.id)
  end
end

describe Checkout, 'with stripe' do
  let(:product) { create(:product, individual_price: 15, company_price: 50) }
  let(:purchase) { build(:purchase, purchaseable: product, payment_method: 'stripe') }
  let(:payment) { stub('payment', :refund => true, :update_user => true, place: true) }
  subject { purchase }

  before do
    Payments::StripePayment.stubs(:new).returns(payment)
  end

  it 'is still a stripe purchase if its coupon discounts 100%' do
    subscription_coupon = stub(apply: 0)
    SubscriptionCoupon.stubs(:new).returns(subscription_coupon)
    purchase = create(:plan_purchase, stripe_coupon_id: 'FREEMONTH')

    expect(purchase).to be_stripe
  end
end

describe Checkout, "after_save" do
  it "copies purchase info to the purchaser" do
    purchase_info_copier_stub = stub("payment_info_copier", copy_info_to_user: true)
    PurchaseInfoCopier.stubs(new: purchase_info_copier_stub)
    user = create(:user)
    purchase = build(:purchase, user: user)
    expect(purchase_info_copier_stub).to have_received(:copy_info_to_user).never

    purchase.save

    expect(PurchaseInfoCopier).to have_received(:new).with(purchase, purchase.user)
    expect(purchase_info_copier_stub).to have_received(:copy_info_to_user)
  end
end

describe Checkout, "given a purchaser" do
  context "for a subscription plan" do
    it "requires a password if there is no user" do
      plan = create(:plan)
      purchase = build(:purchase, purchaseable: plan, user: nil)
      purchase.password = ""

      purchase.save

      expect(purchase.errors[:password]).to include "can't be blank"
    end

    it "creates a user when saved with a password" do
      plan = create(:plan)
      purchase = build(
        :purchase,
        purchaseable: plan,
        user: nil,
        github_usernames: ["cpytel"]
      )
      purchase.password = "test"

      purchase.save!

      expect(purchase.user).to be_persisted
    end
  end
end
