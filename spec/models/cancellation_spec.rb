require "rails_helper"

describe Cancellation do
  describe "#process" do
    before :each do
      subscription.stubs(:stripe_customer_id).returns("cus_1CXxPJDpw1VLvJ")

      mailer = stub(deliver_now: true)
      SubscriptionMailer.stubs(:cancellation_survey).
        with(subscription.user).returns(mailer)
    end

    context "with an active subscription" do
      it "makes the subscription inactive and records the current date" do
        cancellation.process

        expect(subscription.deactivated_on).to eq Time.zone.today
      end

      it "sends a unsubscription survey email" do
        cancellation.process

        expect(SubscriptionMailer).
          to have_received(:cancellation_survey).with(subscription.user)
        expect(SubscriptionMailer.cancellation_survey(subscription.user)).
          to have_received(:deliver_now)
      end
    end

    context "with an inactive subscription" do
      it "doesn't send any updates" do
        subscription.stubs(:active?).returns(false)

        cancellation.process

        expect(SubscriptionMailer.cancellation_survey(subscription.user)).
          to have_received(:deliver_now).never
      end
    end
  end

  describe "#cancel_now" do
    it "makes the subscription inactive and records the current date" do
      subscription.stubs(:stripe_customer_id).returns("cus_1CXxPJDpw1VLvJ")

      cancellation.cancel_now

      expect(subscription.deactivated_on).to eq Time.zone.today
    end

    it "cancels with Stripe" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
      analytics_updater = stub(track_cancelled: true)
      Analytics.stubs(:new).returns(analytics_updater)

      cancellation.cancel_now

      expect(stripe_customer.subscriptions.first).to have_received(:delete)
      expect(analytics_updater).to have_received(:track_cancelled)
    end

    it "retrieves the customer correctly" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)
      subscription.stubs(:stripe_customer_id).returns("cus_1CXxPJDpw1VLvJ")
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      cancellation.cancel_now

      expect(Stripe::Customer).to have_received(:retrieve).
        with("cus_1CXxPJDpw1VLvJ")
    end

    it "does not make the subscription inactive if stripe unsubscribe fails" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)
      stripe_customer.subscriptions.first.stubs(:delete).
        raises(Stripe::InvalidRequestError)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.cancel_now }.to raise_error
      expect(Subscription.find(subscription.id)).to be_active
      expect(Analytics).to have_received(:new).never
    end

    it "does not unsubscribe from stripe if deactivating the subscription failed" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer = stub("Stripe::Customer")
      subscription.stubs(:destroy).raises(ActiveRecord::RecordNotSaved)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.cancel_now }.to raise_error
      expect(subscription).to have_received(:cancel_subscription).never
      expect(Analytics).to have_received(:new).never
    end
  end

  describe "schedule" do
    it "schedules a cancellation with Stripe" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
      analytics_updater = stub(track_cancelled: true)
      Analytics.stubs(:new).returns(analytics_updater)

      cancellation.schedule

      subscription.reload
      expect(stripe_customer.subscriptions.first).
        to have_received(:delete).with(at_period_end: true)
      expect(subscription.scheduled_for_cancellation_on).
        to eq Time.zone.at(1361234235).to_date
      expect(analytics_updater).to have_received(:track_cancelled)
    end

    it "retrieves the customer correctly" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      subscription.stubs(:stripe_customer_id).returns("cus_1CXxPJDpw1VLvJ")
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)
      cancellation.schedule

      expect(Stripe::Customer).to have_received(:retrieve).
        with("cus_1CXxPJDpw1VLvJ")
    end

    it "does not make the subscription inactive if stripe unsubscribe fails" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer.subscriptions.first.stubs(:delete).
        raises(Stripe::InvalidRequestError)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.schedule }.to raise_error
      expect(Subscription.find(subscription.id)).to be_active
      expect(Analytics).to have_received(:new).never
    end

    it "does not unsubscribe from stripe if deactivating the subscription failed" do
      subscription = create(:subscription)
      cancellation = Cancellation.new(subscription)

      stripe_customer = stub("Stripe::Customer")
      subscription.stubs(:destroy).raises(ActiveRecord::RecordNotSaved)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.schedule }.to raise_error
      expect(subscription).to have_received(:cancel_subscription).never
      expect(Analytics).to have_received(:new).never
    end
  end

  describe "cancel_and_refund" do
    it "cancels immediately and refunds the last charge with Stripe" do
      subscription = create(:subscription)
      charge = stub("Stripe::Charge", id: "charge_id", refund: nil)
      subscription.stubs(:last_charge).returns(charge)
      cancellation = Cancellation.new(subscription)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      cancellation.cancel_and_refund

      expect(stripe_customer.subscriptions.first).to have_received(:delete)
      expect(charge).to have_received(:refund)
      expect(subscription.scheduled_for_cancellation_on).to be_nil
    end

    it "does not error if the customer was not charged" do
      subscription = create(:subscription)
      subscription.stubs(:last_charge).returns(nil)
      cancellation = Cancellation.new(subscription)
      Stripe::Customer.stubs(:retrieve).returns(stripe_customer)

      expect { cancellation.cancel_and_refund }.not_to raise_error
      expect(stripe_customer.subscriptions.first).to have_received(:delete)
    end
  end

  describe "#can_downgrade_instead?" do
    it "returns false if the subscribed plan is the downgrade plan" do
      stub_downgrade_plan
      subscribed_plan = build_stubbed(:plan)
      subscription = build_stubbed(:subscription, plan: subscribed_plan)
      cancellation = Cancellation.new(subscription)

      expect(cancellation).to be_can_downgrade_instead
    end

    it "returns true if the subscribed plan is not the downgrade plan" do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription, plan: downgrade_plan)
      cancellation = Cancellation.new(subscription)

      expect(cancellation).to_not be_can_downgrade_instead
    end
  end

  describe "#downgrade_plan" do
    it "returns the basic plan" do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.downgrade_plan).to eq(downgrade_plan)
    end
  end

  describe "#subscribed_plan" do
    it "returns the plan from the subscription" do
      subscription = build_stubbed(:subscription)
      cancellation = Cancellation.new(subscription)

      expect(cancellation.subscribed_plan).to eq(subscription.plan)
    end
  end

  describe "#downgrade" do
    it "switches to the downgrade plan" do
      downgrade_plan = stub_downgrade_plan
      subscription = build_stubbed(:subscription)
      subscription.stubs(:change_plan)
      cancellation = Cancellation.new(subscription)

      cancellation.downgrade

      expect(subscription).to have_received(:change_plan).
        with(sku: downgrade_plan.sku)
    end
  end

  def stub_downgrade_plan
    build_stubbed(:plan).tap do |plan|
      Plan.stubs(:basic).returns(plan)
    end
  end

  def subscription
    @subscription ||= create(:subscription, :purchased)
  end

  def cancellation
    @cancellation ||= Cancellation.new(subscription)
  end

  def stripe_customer
    @stripe_customer ||= stub(
      "Stripe::Customer",
      subscriptions: [
        stub(
          current_period_end: 1361234235,
          delete: true
        )
      ]
    )
  end
end
