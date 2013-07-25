require 'spec_helper'

describe Payments::StripePayment do
  context '#place' do
    it 'charges the customer for a one-off purchase' do
      stub_charge transaction_id: 'TRANSACTION-123'
      purchase = build_oneoff_purchase
      payment = Payments::StripePayment.new(purchase)

      result = payment.place

      result.should be_true
      purchase.payment_transaction_id.should ==  'TRANSACTION-123'
      purchase.should be_paid
    end

    it "updates the customer's plan for a subscription" do
      customer = stub_existing_customer
      purchase = build_plan_purchase
      payment = Payments::StripePayment.new(purchase)

      payment.place

      expect(customer).
        to have_received(:update_subscription).
          with(plan: purchase.purchaseable.sku)
    end

    it 'updates the subscription with the given coupon' do
      customer = stub_existing_customer
      coupon = stub('coupon', amount_off: 25)
      Stripe::Coupon.stubs(:retrieve).returns(coupon)
      purchase = build_plan_purchase(stripe_coupon_id: '25OFF')
      payment = Payments::StripePayment.new(purchase)

      payment.place

      expect(customer).
        to have_received(:update_subscription).
          with(plan: purchase.purchaseable_sku, coupon: '25OFF')
    end

    it "creates a customer if one isn't assigned" do
      stub_charge(customer_id: 'stripe')
      purchase = build_oneoff_purchase
      payment = Payments::StripePayment.new(purchase)

      payment.place

      purchase.stripe_customer_id.should == 'stripe'
    end

    it "doesn't create a customer if one is already assigned" do
      stub_charge
      purchase = build_oneoff_purchase
      purchase.stripe_customer_id = 'original'
      payment = Payments::StripePayment.new(purchase)

      payment.place

      purchase.stripe_customer_id.should == 'original'
    end

    it 'it adds an error message with a bad card' do
      stub_existing_customer
      Stripe::Charge.
        stubs(:create).
        raises(Stripe::StripeError, 'Your card was declined')
      purchase = build_oneoff_purchase
      payment = Payments::StripePayment.new(purchase)

      result = payment.place

      result.should be_false
      purchase.errors[:base].should include(
        'There was a problem processing your credit card, your card was declined'
      )
    end
  end

  context '#update_user' do
    it 'saves the stripe customer id on the user' do
      stub_charge customer_id: 'stripe'
      purchase = build_oneoff_purchase
      payment = Payments::StripePayment.new(purchase)
      payment.place
      user = create(:user, stripe_customer_id: nil)

      payment.update_user(user)

      user.reload.stripe_customer_id.should eq 'stripe'
    end
  end

  context '#refund' do
    it 'refunds money to purchaser' do
      charge = stub_existing_charge(id: 'TRANSACTION-ID')
      purchase = stub_purchase(price: 15, payment_transaction_id: charge.id)
      payment = Payments::StripePayment.new(purchase)

      payment.refund

      Stripe::Charge.should have_received(:retrieve).with('TRANSACTION-ID')
      charge.should have_received(:refund).with(amount: 1500)
    end

    it 'ignores a missing charge' do
      Stripe::Charge.stubs(:retrieve).returns(nil)
      purchase = stub_purchase
      payment = Payments::StripePayment.new(purchase)

      expect { payment.refund }.not_to raise_error
    end

    it 'ignores an already refunded charge' do
      charge = stub_existing_charge(:id => 'TRANSACTION-ID', :refunded => true)
      purchase = stub_purchase(payment_transaction_id: charge.id)
      payment = Payments::StripePayment.new(purchase)

      payment.refund

      charge.should have_received(:refund).never
    end
  end

  def stub_existing_customer
    customer = stub('customer', update_subscription: true)
    Stripe::Customer.stubs(:retrieve).returns(customer)
    customer
  end

  def stub_existing_charge(overides = {})
    attributes = { refunded: false, id: 'TRANSACTION-123' }.merge(overides)
    refunded = stub('refunded_charge', attributes.merge(refunded: true))
    stub('charge', attributes.merge(refund: refunded)).tap do |charge|
      Stripe::Charge.stubs(:retrieve).returns(charge)
    end
  end

  def stub_purchase(overrides = {})
    stub(
      'purchase',
      {
        price: 1,
        payment_transaction_id: 'TRANSACTION-234'
      }.merge(overrides)
    )
  end

  def stub_charge(overrides = {})
    arguments = {
      customer_id: 'stripe',
      transaction_id: 'TRANSACTION-ID'
    }.merge(overrides)

    Stripe::Customer.stubs(:create).returns(stub(id: arguments[:customer_id]))
    Stripe::Charge.stubs(:create).returns(stub(id: arguments[:transaction_id]))
  end

  def build_plan_purchase(overrides = {})
    build(
      :plan_purchase,
      {
        purchaseable: create(:plan),
        payment_method: 'stripe'
      }.merge(overrides)
    )
  end

  def build_oneoff_purchase
    build(
      :purchase,
      purchaseable: build(:product, individual_price: 15, company_price: 50),
      payment_method: 'stripe'
    )
  end
end
