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
      cancellation = build_cancellation
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
      analytics_updater = double("AnalyticsUpdater", track_cancelled: true)
      allow(Analytics).to receive(:new).and_return(analytics_updater)

      cancellation.cancel_now

      expect(stripe_customer.subscriptions.first).to have_received(:delete)
      expect(analytics_updater).to have_received(:track_cancelled)
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
      stripe_invalid_request_error = double("String::InvalidRequestError")
      allow(stripe_customer.subscriptions.first).to receive(:delete).
        and_raise(stripe_invalid_request_error)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.cancel_now }.to raise_error
      expect(subscription.reload).to be_active
      expect(Analytics).not_to have_received(:new)
    end

    it "does not unsubscribe from stripe if deactivating the subscription failed" do
      cancellation = build_cancellation(subscription: subscription)

      stripe_customer = double("Stripe::Customer")
      allow(subscription).to receive(:destroy).
        and_raise(ActiveRecord::RecordNotSaved, "error")
      allow(subscription).to receive(:cancel_subscription)
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.cancel_now }.to raise_error
      expect(subscription).not_to have_received(:cancel_subscription)
      expect(Analytics).not_to have_received(:new)
    end
  end

  describe "schedule" do
    it "schedules a cancellation with Stripe" do
      cancellation = build_cancellation(subscription: subscription)
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
      analytics_updater = double("AnalyticsUpdater", track_cancelled: true)
      allow(Analytics).to receive(:new).and_return(analytics_updater)

      cancellation.schedule

      subscription.reload
      expect(stripe_customer.subscriptions.first).
        to have_received(:delete).with(at_period_end: true)
      expect(subscription.scheduled_for_cancellation_on).
        to eq Time.zone.at(1361234235).to_date
      expect(analytics_updater).
        to have_received(:track_cancelled).with("reason")
    end

    it "returns true when valid" do
      cancellation = build_cancellation
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      analytics_updater = double("AnalyticsUpdater", track_cancelled: true)
      allow(Analytics).to receive(:new).with(anything).
        and_return(analytics_updater)

      expect(cancellation.schedule).to eq true
    end

    it "returns false when invalid" do
      cancellation = build_cancellation(reason: nil)
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
      analytics_updater = double("AnalyticsUpdater", track_cancelled: true)
      allow(Analytics).to receive(:new).and_return(analytics_updater)

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

      stripe_invalid_request_error = double("String::InvalidRequestError")
      allow(stripe_customer.subscriptions.first).to receive(:delete).
        and_raise(stripe_invalid_request_error)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.schedule }.to raise_error
      expect(subscription.reload).to be_active
      expect(Analytics).not_to have_received(:new)
    end

    it "does not unsubscribe from stripe if deactivating the subscription failed" do
      cancellation = build_cancellation(subscription: subscription)

      stripe_customer = double("Stripe::Customer")
      allow(subscription).to receive(:destroy).
        and_raise(ActiveRecord::RecordNotSaved, "error")
      allow(subscription).to receive(:cancel_subscription)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.schedule }.to raise_error
      expect(subscription).not_to have_received(:cancel_subscription)
      expect(Analytics).not_to have_received(:new)
    end
  end

  describe "cancel_and_refund" do
    it "cancels immediately and refunds the last charge with Stripe" do
      charge = double("Stripe::Charge", id: "charge_id", refund: nil)
      allow(subscription).to receive(:last_charge).and_return(charge)
      cancellation = build_cancellation(subscription: subscription)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)

      cancellation.cancel_and_refund

      expect(stripe_customer.subscriptions.first).to have_received(:delete)
      expect(charge).to have_received(:refund)
      expect(subscription.scheduled_for_cancellation_on).to be_nil
    end

    it "does not error if the customer was not charged" do
      allow(subscription).to receive(:last_charge).and_return(nil)
      cancellation = build_cancellation(subscription: subscription)
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)

      expect { cancellation.cancel_and_refund }.not_to raise_error
      expect(stripe_customer.subscriptions.first).to have_received(:delete)
    end
  end

  describe "#can_downgrade_instead?" do
    it "returns false if the subscriber is already on the downgraded plan" do
      downgraded_plan = build_stubbed(:plan)
      subscription = build_stubbed(:subscription, plan: downgraded_plan)
      cancellation = build_cancellation(
        subscription: subscription,
        downgrade_plan: downgraded_plan
      )

      expect(cancellation.can_downgrade_instead?).to be_falsey
    end

    it "returns true if the subscribed plan is not the downgrade plan" do
      downgrade_plan = build_stubbed(:plan)
      other_plan = build_stubbed(:plan)
      subscription = build_stubbed(:subscription, plan: other_plan)
      cancellation = build_cancellation(
        subscription: subscription,
        downgrade_plan: downgrade_plan
      )

      expect(cancellation.can_downgrade_instead?).to be_truthy
    end
  end

  describe "#downgrade_plan" do
    it "returns the injected plan" do
      downgrade_plan = build_stubbed(:plan)
      cancellation = build_cancellation(
        downgrade_plan: downgrade_plan
      )

      expect(cancellation.downgrade_plan).to eq(downgrade_plan)
    end
  end

  describe "#subscribed_plan" do
    it "returns the plan from the subscription" do
      subscription = build_stubbed(:subscription)
      cancellation = build_cancellation(subscription: subscription)

      expect(cancellation.subscribed_plan).to eq(subscription.plan)
    end
  end

  describe "#downgrade" do
    it "switches to the downgrade plan" do
      downgrade_plan = build_stubbed(:plan)
      subscription = build_stubbed(:subscription)
      allow(subscription).to receive(:change_plan)
      cancellation = build_cancellation(
        subscription: subscription,
        downgrade_plan: downgrade_plan
      )

      cancellation.downgrade

      expect(subscription).to have_received(:change_plan).
        with(sku: downgrade_plan.sku)
    end
  end

  def build_cancellation(subscription: create(:subscription),
                         downgrade_plan: create(:plan),
                         reason: "reason")
    Cancellation.new(
      subscription: subscription,
      downgrade_plan: downgrade_plan,
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
          current_period_end: 1361234235,
          delete: true
        )
      ]
    )
  end
end
