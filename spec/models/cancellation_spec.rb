require "rails_helper"

describe Cancellation do
  it "should be ActiveModel-compliant" do
    cancellation = Cancellation.new(subscription, "reason")
    expect(cancellation).to be_a(ActiveModel::Model)
  end

  it "validates presence of reason" do
    cancellation = Cancellation.new(subscription, "")

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
      cancellation = Cancellation.new(subscription, "reason")
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
      analytics_updater = double("AnalyticsUpdater", track_cancelled: true)
      allow(Analytics).to receive(:new).and_return(analytics_updater)

      cancellation.cancel_now

      expect(stripe_customer.subscriptions.first).to have_received(:delete)
      expect(analytics_updater).to have_received(:track_cancelled)
    end

    it "retrieves the customer correctly" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")
      allow(subscription).to receive(:stripe_customer_id).
        and_return("cus_1CXxPJDpw1VLvJ")
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)

      cancellation.cancel_now

      expect(Stripe::Customer).to have_received(:retrieve).
        with("cus_1CXxPJDpw1VLvJ")
    end

    it "does not make the subscription inactive if stripe unsubscribe fails" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")
      stripe_invalid_request_error = double("String::InvalidRequestError")
      allow(stripe_customer.subscriptions.first).to receive(:delete).
        and_raise(stripe_invalid_request_error)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.cancel_now }.to raise_error
      expect(Subscription.find(subscription.id)).to be_active
      expect(Analytics).not_to have_received(:new)
    end

    it "does not unsubscribe from stripe if deactivating the subscription failed" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")

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
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")
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
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      analytics_updater = double("AnalyticsUpdater", track_cancelled: true)
      allow(Analytics).to receive(:new).with(anything).
        and_return(analytics_updater)

      expect(cancellation.schedule).to eq true
    end

    it "returns false when invalid" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "")
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
      analytics_updater = double("AnalyticsUpdater", track_cancelled: true)
      allow(Analytics).to receive(:new).and_return(analytics_updater)

      expect(cancellation.schedule).to eq false
    end

    it "retrieves the customer correctly" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")

      allow(subscription).to receive(:stripe_customer_id).
        and_return("cus_1CXxPJDpw1VLvJ")
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      cancellation.schedule

      expect(Stripe::Customer).to have_received(:retrieve).
        with("cus_1CXxPJDpw1VLvJ")
    end

    it "does not make the subscription inactive if stripe unsubscribe fails" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")

      stripe_invalid_request_error = double("String::InvalidRequestError")
      allow(stripe_customer.subscriptions.first).to receive(:delete).
        and_raise(stripe_invalid_request_error)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.schedule }.to raise_error
      expect(Subscription.find(subscription.id)).to be_active
      expect(Analytics).not_to have_received(:new)
    end

    it "does not unsubscribe from stripe if deactivating the subscription failed" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription, "reason")

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
      subscription = create(:subscription)
      charge = double("Stripe::Charge", id: "charge_id", refund: nil)
      allow(subscription).to receive(:last_charge).and_return(charge)
      cancellation = Cancellation.new(subscription, "reason")
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)

      cancellation.cancel_and_refund

      expect(stripe_customer.subscriptions.first).to have_received(:delete)
      expect(charge).to have_received(:refund)
      expect(subscription.scheduled_for_cancellation_on).to be_nil
    end

    it "does not error if the customer was not charged" do
      subscription = create(:subscription)
      allow(subscription).to receive(:last_charge).and_return(nil)
      cancellation = Cancellation.new(subscription, "reason")
      allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)

      expect { cancellation.cancel_and_refund }.not_to raise_error
      expect(stripe_customer.subscriptions.first).to have_received(:delete)
    end
  end

  describe "#can_downgrade_instead?" do
    it "returns false if the subscribed plan is the downgrade plan" do
      stub_downgrade_plan
      subscribed_plan = build_stubbed(:plan)
      subscription = build_stubbed(:subscription, plan: subscribed_plan)
      cancellation = Cancellation.new(subscription, "reason")

      expect(cancellation).to be_can_downgrade_instead
    end

    it "returns true if the subscribed plan is not the downgrade plan" do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription, plan: downgrade_plan)
      cancellation = Cancellation.new(subscription, "reason")

      expect(cancellation).to_not be_can_downgrade_instead
    end
  end

  describe "#downgrade_plan" do
    it "returns the basic plan" do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription)
      cancellation = Cancellation.new(subscription, "reason")

      expect(cancellation.downgrade_plan).to eq(downgrade_plan)
    end
  end

  describe "#subscribed_plan" do
    it "returns the plan from the subscription" do
      subscription = build_stubbed(:subscription)
      cancellation = Cancellation.new(subscription, "reason")

      expect(cancellation.subscribed_plan).to eq(subscription.plan)
    end
  end

  describe "#downgrade" do
    it "switches to the downgrade plan" do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription)
      allow(subscription).to receive(:change_plan)
      cancellation = Cancellation.new(subscription, "reason")

      cancellation.downgrade

      expect(subscription).to have_received(:change_plan).
        with(sku: downgrade_plan.sku)
    end
  end

  def stub_downgrade_plan
    build_stubbed(:plan).tap do |plan|
      allow(Plan).to receive(:basic).and_return(plan)
    end
  end

  def subscription
    @subscription ||= create(:subscription, :purchased)
  end

  def cancellation
    @cancellation ||= Cancellation.new(subscription, "reason")
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
