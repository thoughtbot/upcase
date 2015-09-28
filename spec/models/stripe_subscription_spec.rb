require "rails_helper"

describe StripeSubscription do
  context '#create' do
    context "when there is an existing Stripe Customer record" do
      it "updates the user's credit card" do
        customer = stub_existing_customer
        allow(customer).to receive(:card=)
        allow(customer).to receive(:save)
        checkout = build(
          :checkout,
          stripe_customer_id: "abc123",
          stripe_token: "token123"
        )
        subscription = StripeSubscription.new(checkout)

        subscription.create

        expect(customer).to have_received(:card=).with("token123")
        expect(customer).to have_received(:save)
      end

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
        checkout = build(:checkout, plan: create(:plan, minimum_quantity: 5))
        subscription = StripeSubscription.new(checkout)

        subscription.create

        new_subscription = customer.subscriptions.first
        expect(new_subscription[:plan]).to eq checkout.plan_sku
        expect(new_subscription[:quantity]).to eq 5
      end

      it "updates the subscription with the given coupon" do
        customer = stub_existing_customer
        coupon = double("coupon", amount_off: 25)
        allow(Stripe::Coupon).to receive(:retrieve).and_return(coupon)
        checkout = build(:checkout, stripe_coupon_id: "25OFF")
        subscription = StripeSubscription.new(checkout)

        subscription.create

        new_subscription = customer.subscriptions.first
        expect(new_subscription[:plan]).to eq checkout.plan_sku
        expect(new_subscription[:coupon]).to eq "25OFF"
        expect(new_subscription[:quantity]).to eq 1
      end
    end

    it "creates a customer if one isn't assigned" do
      checkout = build(:checkout, user: create(:user))
      stub_stripe_customer(returning_customer_id: "stripe")
      subscription = StripeSubscription.new(checkout)

      subscription.create

      expect(checkout.stripe_customer_id).to eq "stripe"
      expect(Stripe::Customer).to have_received(:create).
        with(hash_including(email: checkout.user_email))
    end

    it "doesn't create a customer if one is already assigned" do
      checkout = build(:checkout)
      checkout.stripe_customer_id = "original"
      stub_stripe_customer
      subscription = StripeSubscription.new(checkout)

      subscription.create

      expect(checkout.stripe_customer_id).to eq "original"
      expect(Stripe::Customer).not_to have_received(:create)
    end

    it "it adds an error message with a bad card" do
      allow(Stripe::Customer).to receive(:create).
        and_raise(Stripe::StripeError, "Your card was declined")
      checkout = build(:checkout)
      subscription = StripeSubscription.new(checkout)

      result = subscription.create

      expect(result).to be false
      expect(checkout.errors[:base]).to include(
        I18n.t("checkout.problem_with_card", message: "your card was declined")
      )
    end
  end

  def stub_existing_customer
    subscriptions = FakeSubscriptionList.new([FakeSubscription.new])
    customer = double("customer", subscriptions: subscriptions)
    allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
    customer
  end

  def stub_stripe_customer(returning_customer_id: "unspecified")
    allow(Stripe::Customer).to receive(:create).
      and_return(double("StripeCustomer", id: returning_customer_id))
  end
end
