require "rails_helper"

describe Cancellation do
  it "should be ActiveModel-compliant" do
    cancellation = build_cancellation

    expect(cancellation).to be_a(ActiveModel::Model)
  end

  it "validates presence of reason" do
    cancellation = build_cancellation(reason: "")

    expect(cancellation).to be_invalid
    expect(cancellation.errors[:reason]).to eq(["can't be blank"])
  end

  describe "#process" do
    before :each do
      allow(subscription).to receive(:stripe_customer_id).
        and_return("cus_1CXxPJDpw1VLvJ")
    end

    context "with an active subscription" do
      it "makes the subscription inactive and records the current date" do
        cancellation.process

        expect(subscription.deactivated_on).to eq Time.zone.today
      end
    end
  end

  describe "#cancel_now" do
    it "makes the subscription inactive and records the current date" do
      allow(subscription).to receive(:stripe_customer_id).
        and_return("cus_1CXxPJDpw1VLvJ")

      cancellation.cancel_now

      expect(subscription.deactivated_on).to eq Time.zone.today
    end

    it "cancels with Stripe" do
      subscription = create(:subscription)
      cancellation = build_cancellation(subscription: subscription)
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)

      cancellation.cancel_now

      expect(stripe_customer.subscriptions.first).to have_received(:delete)
      expect(analytics).to have_tracked("Cancelled").
        for_user(subscription.user).
        with_properties(reason: "reason")
    end

    it "retrieves the customer correctly" do
      cancellation = build_cancellation(subscription: subscription)
      allow(subscription).to receive(:stripe_customer_id).
        and_return("cus_1CXxPJDpw1VLvJ")
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)

      cancellation.cancel_now

      expect(Stripe::Customer).to have_received(:retrieve).
        with("cus_1CXxPJDpw1VLvJ")
    end

    it "does not make the subscription inactive if stripe unsubscribe fails" do
      cancellation = build_cancellation(subscription: subscription)
      allow(stripe_customer.subscriptions.first).to receive(:delete).
        and_raise(Stripe::StripeError)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.cancel_now }.to raise_error(Stripe::StripeError)
      expect(subscription.reload).to be_active
      expect(Analytics).not_to have_received(:new)
    end
  end

  describe "#schedule" do
    it "schedules a cancellation with Stripe" do
      Timecop.freeze(Time.current) do
        cancellation = build_cancellation(subscription: subscription)
        allow(Stripe::Customer).to(
          receive(:retrieve).and_return(stripe_customer),
        )

        cancellation.schedule

        subscription.reload
        expect(stripe_customer.subscriptions.first).
          to have_received(:delete).with(at_period_end: true)
        expect(subscription.scheduled_for_deactivation_on).
          to eq Time.zone.at(billing_period_end).to_date
        expect(subscription.user_clicked_cancel_button_on).
          to eq Date.current
        expect(analytics).to have_tracked("Cancelled").
          for_user(subscription.user).
          with_properties(reason: "reason")
      end
    end

    it "returns true when valid" do
      cancellation = build_cancellation
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)

      expect(cancellation.schedule).to eq true
    end

    it "returns false when invalid" do
      cancellation = build_cancellation(reason: nil)
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)

      expect(cancellation.schedule).to eq false
    end

    it "retrieves the customer correctly" do
      cancellation = build_cancellation(subscription: subscription)

      allow(subscription).to receive(:stripe_customer_id).
        and_return("cus_1CXxPJDpw1VLvJ")
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      cancellation.schedule

      expect(Stripe::Customer).to have_received(:retrieve).
        with("cus_1CXxPJDpw1VLvJ")
    end

    it "does not make the subscription inactive if stripe unsubscribe fails" do
      cancellation = build_cancellation(subscription: subscription)
      allow(stripe_customer.subscriptions.first).to receive(:delete).
        and_raise(Stripe::StripeError)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.schedule }.to raise_error(Stripe::StripeError)
      expect(subscription.reload).to be_active
      expect(Analytics).not_to have_received(:new)
    end
  end

  describe "#subscribed_plan" do
    it "returns the plan from the subscription" do
      subscription = build_stubbed(:subscription)
      cancellation = build_cancellation(subscription: subscription)

      expect(cancellation.subscribed_plan).to eq(subscription.plan)
    end
  end

  def build_cancellation(subscription: create(:subscription),
                         reason: "reason")
    Cancellation.new(
      subscription: subscription,
      reason: reason
    )
  end

  def subscription
    @subscription ||= create(:subscription, :purchased)
  end

  def cancellation
    @cancellation ||= build_cancellation(subscription: subscription)
  end

  def stripe_customer
    @stripe_customer ||= double(
      "Stripe::Customer",
      subscriptions: [
        double(
          "Subscription",
          current_period_end: billing_period_end,
          delete: true
        )
      ]
    )
  end

  def billing_period_end
    1361234235
  end
end
