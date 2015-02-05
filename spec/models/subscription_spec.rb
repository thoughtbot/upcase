require "rails_helper"

describe Subscription do
  it { should have_one(:team).dependent(:destroy) }
  it { should belong_to(:plan) }
  it { should belong_to(:user) }

  it { should delegate(:stripe_customer_id).to(:user) }

  it { should validate_presence_of(:plan_id) }
  it { should validate_presence_of(:plan_type) }
  it { should validate_presence_of(:user_id) }

  describe ".deliver_welcome_emails" do
    it "sends emails for each new mentored subscriber in the last 24 hours" do
      plan = create(:plan, includes_mentor: true)
      old_subscription =
        create(:subscription, plan: plan, created_at: 25.hours.ago)
      new_subscription =
        create(:subscription, plan: plan, created_at: 10.hours.ago)
      mailer = spy("Mailer")
      allow(SubscriptionMailer).to receive(:welcome_to_upcase_from_mentor).
        and_return(mailer)

      Subscription.deliver_welcome_emails

      expect(SubscriptionMailer).
        to have_received(:welcome_to_upcase_from_mentor).
        with(new_subscription.user)
      expect(SubscriptionMailer).
        not_to have_received(:welcome_to_upcase_from_mentor).
        with(old_subscription.user)
      expect(mailer).to have_received(:deliver_now).once
    end
  end

  describe ".next_payment_in_2_days" do
    it "only includes subscription that will be billed in 2 days" do
      billed_today = create(:subscription, next_payment_on: Date.current)
      billed_tomorrow = create(:subscription, next_payment_on: Date.current + 1.day)
      billed_2_days_from_now = create(:subscription, next_payment_on: Date.current + 2.days)
      billed_3_days_from_now = create(:subscription, next_payment_on: Date.current + 3.days)

      expect(Subscription.next_payment_in_2_days).to eq [billed_2_days_from_now]
    end
  end

  describe "#active?" do
    it "returns true if deactivated_on is nil" do
      subscription = Subscription.new(deactivated_on: nil)
      expect(subscription).to be_active
    end

    it "returns false if deactivated_on is not nil" do
      subscription = Subscription.new(deactivated_on: Time.zone.today)
      expect(subscription).not_to be_active
    end
  end

  describe "#scheduled_for_cancellation?" do
    it "returns false if scheduled_for_cancellation_on is nil" do
      subscription = Subscription.new(scheduled_for_cancellation_on: nil)

      expect(subscription).not_to be_scheduled_for_cancellation
    end

    it "returns true if scheduled_for_cancellation_on is not nil" do
      subscription = Subscription.new(
        scheduled_for_cancellation_on: Time.zone.today
      )

      expect(subscription).to be_scheduled_for_cancellation
    end
  end

  describe "#deactivate" do
    it "updates the subscription record by setting deactivated_on to today" do
      subscription = create(:active_subscription, :purchased)

      subscription.deactivate
      subscription.reload

      expect(subscription.deactivated_on).to eq Time.zone.today
    end

    it "unfulfills itself" do
      fulfillment = spy("fulfillment")
      subscription = create(:active_subscription)
      allow(SubscriptionFulfillment).to receive(:new).
        with(subscription.user, subscription.plan).
        and_return(fulfillment)

      subscription.deactivate

      expect(fulfillment).to have_received(:remove)
    end

    it "unfulfills for a user who changed their plan" do
      original_plan = create(:plan)
      new_plan = create(:plan)
      subscription = create(:active_subscription, plan: new_plan)
      create(
        :checkout,
        user: subscription.user,
        plan: original_plan
      )

      expect { subscription.deactivate }.not_to raise_error
    end
  end

  describe "#change_plan" do
    it "updates upcase and stripe plans" do
      subscription = build(:subscription)
      allow(subscription).to receive(:write_plan)
      allow(subscription).to receive(:change_stripe_plan)
      sku = "plan_sku"

      subscription.change_plan(sku: sku)

      expect(subscription).to have_received(:write_plan).with(sku: sku)
      expect(subscription).to have_received(:change_stripe_plan).with(sku: sku)
    end
  end

  describe "#change_stripe_plan" do
    it "updates the plan in Stripe" do
      different_plan = create(:plan, sku: "different")
      stripe_customer = setup_cutomer
      subscription = create(:active_subscription)

      subscription.change_stripe_plan(sku: different_plan.sku)

      expect(stripe_customer.subscriptions.first.plan).to eq different_plan.sku
    end
  end

  describe "#write_plan" do
    context "when subscription is for an individual" do
      it "notifies Analytics for current user" do
        analytics_updater = spy("AnalyticsUpdater")
        allow(Analytics).to receive(:new).and_return(analytics_updater)
        subscription = create(:subscription, team: nil)

        subscription.write_plan(sku: create(:plan).sku)

        expect(Analytics).to have_received(:new).with(subscription.user)
        expect(analytics_updater).to have_received(:track_updated)
      end
    end

    context "when subscription is for a team" do
      it "notifies Analytics for all users in the team" do
        analytics_updater = spy("AnalyticsUpdater")
        allow(Analytics).to receive(:new).and_return(analytics_updater)
        users = create_list(:user, 2)
        team = create(:team, users: users)
        subscription = create(:team_subscription, team: team, user: users.first)

        subscription.write_plan(sku: create(:plan).sku)

        expect(Analytics).to have_received(:new).with(users.first)
        expect(Analytics).to have_received(:new).with(users.second)
        expect(analytics_updater).to have_received(:track_updated).twice
      end
    end

    it "changes the subscription plan to the given plan" do
      different_plan = create(:plan, sku: "different")
      subscription = create(:active_subscription)

      subscription.write_plan(sku: different_plan.sku)

      expect(subscription.plan).to eq different_plan
    end

    it "fulfills features gained by the new plan" do
      subscription = create(:active_subscription)
      feature_fulfillment = stub_feature_fulfillment
      subscription.write_plan(sku: build_stubbed(:plan).sku)
      expect(feature_fulfillment).to have_received(:fulfill_gained_features)
    end

    it "unfulfills features lost by the old plan" do
      subscription = create(:active_subscription)
      feature_fulfillment = stub_feature_fulfillment
      subscription.write_plan(sku: build_stubbed(:plan).sku)
      expect(feature_fulfillment).to have_received(:unfulfill_lost_features)
    end

    def stub_feature_fulfillment
      fulfillment = spy("FeatureFulfillment")
      allow(FeatureFulfillment).to receive(:new).and_return(fulfillment)
      fulfillment
    end
  end

  describe "#change_quantity" do
    it "updates the plan in Stripe" do
      stripe_customer = setup_cutomer
      subscription = create(:active_subscription)

      subscription.change_quantity(4)

      expect(stripe_customer.subscriptions.first.quantity).to eq 4
    end
  end

  describe "#has_access_to?" do
    context "when the subscription is inactive" do
      it "returns false" do
        subscription = build_stubbed(:subscription, deactivated_on: Date.today)

        expect(subscription).to_not have_access_to("video_tutorials")
      end
    end

    context "when subscription is active but does not include feature" do
      it "returns false" do
        plan = create(:plan, includes_video_tutorials: false)
        subscription = build_stubbed(:subscription, plan: plan)

        expect(subscription).to_not have_access_to("video_tutorials")
      end
    end

    context "when subscription is active and includes feature" do
      it "returns true" do
        plan = create(:plan, includes_video_tutorials: true)
        subscription = build_stubbed(:subscription, plan: plan)

        expect(subscription).to have_access_to("video_tutorials")
      end
    end
  end

  describe "#plan_name" do
    it "delegates to plan" do
      plan = build_stubbed(:plan, name: "Individual")
      subscription = build_stubbed(:subscription, plan: plan)

      expect(subscription.plan_name).to eq "Individual"
    end
  end

  describe ".canceled_in_last_30_days" do
    it "returns nothing when none have been canceled within 30 days" do
      create(:subscription, deactivated_on: 60.days.ago)

      expect(Subscription.canceled_in_last_30_days).to be_empty
    end

    it "returns the subscriptions canceled within 30 days" do
      subscription = create(:subscription, deactivated_on: 7.days.ago)

      expect(Subscription.canceled_in_last_30_days).to eq [subscription]
    end
  end

  describe ".active_as_of" do
    it "returns nothing when no subscriptions canceled" do
      expect(Subscription.active_as_of(Time.zone.now)).to be_empty
    end

    it "returns nothing when subscription canceled before the given date" do
      create(:subscription, deactivated_on: 9.days.ago)

      expect(Subscription.active_as_of(8.days.ago)).to be_empty
    end

    it "returns the subscriptions canceled after the given date" do
      subscription = create(:subscription, deactivated_on: 7.days.ago)

      expect(Subscription.active_as_of(8.days.ago)).to eq [subscription]
    end

    it "returns the subscriptions not canceled" do
      subscription = create(:subscription)

      expect(Subscription.active_as_of(8.days.ago)).to eq [subscription]
    end
  end

  describe ".created_before" do
    it "returns nothing when the are no subscriptions" do
      expect(Subscription.created_before(Time.zone.now)).to be_empty
    end

    it "returns nothing when nothing has been created before the given date" do
      create(:subscription, created_at: 1.day.ago)

      expect(Subscription.created_before(2.days.ago)).to be_empty
    end

    it "returns the subscriptions created before the given date" do
      subscription = create(:subscription, created_at: 2.days.ago)

      expect(Subscription.created_before(1.day.ago)).to eq [subscription]
    end
  end

  describe "#team?" do
    it "returns true with a team" do
      subscription = create(:team).subscription

      expect(subscription).to be_team
    end

    it "returns false without a team" do
      subscription = build_stubbed(:subscription)

      expect(subscription).to_not be_team
    end
  end

  describe "#last_charge" do
    it "returns the last charge for the customer" do
      charge = double("Stripe::Charge")
      allow(Stripe::Charge).to receive(:all).and_return([charge])
      subscription = build_stubbed(:subscription)

      expect(subscription.last_charge).to eq charge
      expect(Stripe::Charge).to have_received(:all)
        .with(count: 1, customer: subscription.stripe_customer_id)
    end
  end

  describe "owner?" do
    context "when the given user is the owner" do
      it "returns true" do
        user = User.new
        subscription = build_stubbed(:subscription, user: user)

        expect(subscription.owner?(user)).to eq true
      end
    end

    context "when the given user is not the owner" do
      it "returns false" do
        user = User.new
        subscription = build_stubbed(:subscription)

        expect(subscription.owner?(user)).to eq false
      end
    end
  end

  describe "next_payment_amount_in_dollars" do
    it "returns the next payment amount in dollars" do
      subscription = build(:subscription, next_payment_amount: 1000)

      expect(subscription.next_payment_amount_in_dollars).to eq 10
    end
  end

  def setup_cutomer
    stripe_customer = double(
      "StripeCustomer",
      subscriptions: [FakeSubscription.new]
    )
    allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_customer)
    stripe_customer
  end
end
