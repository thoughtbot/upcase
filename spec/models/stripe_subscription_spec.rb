require "rails_helper"

describe StripeSubscription do
  context '#create' do
    it "updates the customer's plan" do
      customer = stub_existing_customer
      checkout = build(:checkout)
      subscription = StripeSubscription.new(checkout)

      subscription.create

      new_subscription = customer.subscriptions.first
      expect(new_subscription[:plan]).to eq checkout.plan_sku
      expect(new_subscription[:quantity]).to eq 1
    end

    it "updates the customer's plan with the given quantity" do
      customer = stub_existing_customer
      checkout = build(:checkout)
      checkout.quantity = 5
      subscription = StripeSubscription.new(checkout)

      subscription.create

      new_subscription = customer.subscriptions.first
      expect(new_subscription[:plan]).to eq checkout.plan_sku
      expect(new_subscription[:quantity]).to eq checkout.quantity
    end

    it "updates the subscription with the given coupon" do
      customer = stub_existing_customer
      coupon = stub("coupon", amount_off: 25)
      Stripe::Coupon.stubs(:retrieve).returns(coupon)
      checkout = build(:checkout, stripe_coupon_id: "25OFF")
      subscription = StripeSubscription.new(checkout)

      subscription.create

      new_subscription = customer.subscriptions.first
      expect(new_subscription[:plan]).to eq checkout.plan_sku
      expect(new_subscription[:coupon]).to eq "25OFF"
      expect(new_subscription[:quantity]).to eq 1
    end

    it "creates a customer if one isn't assigned" do
      stub_stripe_customer(customer_id: "stripe")
      checkout = build(:checkout, user: create(:user))
      subscription = StripeSubscription.new(checkout)

      subscription.create

      expect(checkout.stripe_customer_id).to eq "stripe"
    end

    it "doesn't create a customer if one is already assigned" do
      stub_stripe_customer
      checkout = build(:checkout)
      checkout.stripe_customer_id = 'original'
      subscription = StripeSubscription.new(checkout)

      subscription.create

      expect(checkout.stripe_customer_id).to eq "original"
    end

    it "it adds an error message with a bad card" do
      stub_stripe_customer
      Stripe::Customer.
        stubs(:create).
        raises(Stripe::StripeError, "Your card was declined")
      checkout = build(:checkout)
      subscription = StripeSubscription.new(checkout)

      result = subscription.create

      expect(result).to be false
      expect(checkout.errors[:base]).to include(
        "There was a problem processing your credit card, your card was declined"
      )
    end
  end

  context "#update_user" do
    it "saves the stripe customer id on the user" do
      stub_stripe_customer customer_id: 'stripe'
      checkout = build(:checkout)
      subscription = StripeSubscription.new(checkout)
      subscription.create
      user = create(:user, stripe_customer_id: nil)

      subscription.update_user(user)

      expect(user.reload.stripe_customer_id).to eq "stripe"
    end
  end

  def stub_existing_customer
    subscriptions = FakeSubscriptionList.new([FakeSubscription.new])
    customer = stub("customer", subscriptions: subscriptions)
    Stripe::Customer.stubs(:retrieve).returns(customer)
    customer
  end

  def stub_stripe_customer(overrides = {})
    arguments = {
      customer_id: 'stripe',
    }.merge(overrides)

    Stripe::Customer.stubs(:create).returns(stub(id: arguments[:customer_id]))
  end
end
