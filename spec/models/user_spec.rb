require "rails_helper"

describe User do
  context "associations" do
    it { should belong_to(:team) }
    it { should have_many(:attempts).dependent(:destroy) }
    it { should have_many(:collaborations).dependent(:destroy) }
    it { should have_many(:statuses).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:github_username) }
    it { should validate_uniqueness_of(:github_username) }
  end

  context "#first_name" do
    it "has a first_name that is the first part of name" do
      user = User.new(name: "first last")
      expect(user.first_name).to eq "first"
    end
  end

  context "#last_name" do
    it "returns everything except the first name" do
      user = User.new(name: "First Last")
      expect(user.last_name).to eq "Last"

      user_with_multi_part_last_name = User.new(name: "First van der Last")
      expect(user_with_multi_part_last_name.last_name).to eq "van der Last"
    end
  end

  context "#inactive_subscription" do
    it "returns the user's associated subscription if it is inactive" do
      user = User.new
      subscription = build_stubbed(:inactive_subscription)
      allow(user).to receive(:subscriptions).and_return([subscription])

      expect(user.inactive_subscription).to be subscription
    end

    it "returns nil if the user's associated subscription is active" do
      user = User.new
      subscription = build_stubbed(:active_subscription)
      allow(user).to receive(:subscriptions).and_return([subscription])

      expect(user.inactive_subscription).to be nil
    end

    it "returns nil if the user doesn't even have a subscription" do
      user = User.new
      expect(user.inactive_subscription).to be nil
    end

    context "with an active subscription and an inactive team subscription" do
      it "returns nil" do
        user = create(
          :user,
          :with_subscription,
          :with_inactive_team_subscription
        )

        expect(user.inactive_subscription).to be nil
      end
    end

    context "with an inactive subscription and an active team subscription" do
      it "returns nil" do
        user = create(
          :user,
          :with_inactive_subscription,
          :with_team_subscription
        )

        expect(user.inactive_subscription).to be nil
      end
    end

    context "with an inactive subscription and an inactive team subscription" do
      it "returns the subscription most recently deactivated" do
        user = create(
          :user,
          :with_inactive_subscription,
          :with_inactive_team_subscription
        )
        user.team.subscription.update_attributes!(
          deactivated_on: user.subscriptions.first.deactivated_on + 1.day
        )

        expect(user.inactive_subscription).to eq(user.team.subscription)
      end
    end
  end

  context "#deactivate_personal_subscription" do
    it "cancels subscription" do
      user = create(:user, :with_subscription)
      cancellation = double("Cancellation", cancel_now: true)
      allow(Cancellation).to receive(:new).and_return(cancellation)

      user.deactivate_personal_subscription

      expect(Cancellation).to have_received(:new)
    end

    it "doesn't cancel deactivated subscription" do
      user = create(:user, :with_inactive_subscription)
      cancellation = double("Cancellation", cancel_now: true)
      allow(Cancellation).to receive(:new).and_return(cancellation)

      user.deactivate_personal_subscription

      expect(Cancellation).not_to have_received(:new)
    end
  end

  context "#has_active_subscription?" do
    it "returns true if the user's associated subscription is active" do
      user = User.new
      subscription = build_stubbed(:active_subscription)
      allow(user).to receive(:subscriptions).and_return([subscription])

      expect(user).to have_active_subscription
    end

    it "returns true with an active team subscription" do
      team = Team.new
      team.subscription = build_stubbed(:active_subscription)
      user = User.new
      user.team = team
      expect(user).to have_active_subscription
    end

    it "returns false with an inactive team subscription" do
      team = Team.new
      team.subscription = build_stubbed(:inactive_subscription)
      user = User.new
      user.team = team
      expect(user).not_to have_active_subscription
    end

    it "returns false if the user's associated subscription is not active" do
      user = User.new
      subscription = build_stubbed(:inactive_subscription)
      allow(user).to receive(:subscriptions).and_return([subscription])

      expect(user).not_to have_active_subscription
    end

    it "returns false if the user doesn't even have a subscription" do
      user = User.new

      expect(user).not_to have_active_subscription
    end

    context "with an inactive subscription and an active team subscription" do
      it "returns true" do
        user = create(
          :user,
          :with_inactive_subscription,
          :with_team_subscription
        )

        expect(user).to have_active_subscription
      end
    end

    context "with an active subscription and an inactive team subscription" do
      it "returns true" do
        user = create(
          :user,
          :with_subscription,
          :with_inactive_team_subscription
        )

        expect(user).to have_active_subscription
      end
    end

    context "with an inactive subscription and an inactive team subscription" do
      it "returns false" do
        user = create(
          :user,
          :with_inactive_subscription,
          :with_inactive_team_subscription
        )

        expect(user).not_to have_active_subscription
      end
    end
  end

  describe "#subscribed_at" do
    it "returns the date the user subscribed if the user has a subscription" do
      user = create(:subscriber)

      expect(user.subscribed_at).to eq user.subscription.created_at
    end

    it "returns nil when the user does not have a subscription" do
      user = create(:user)

      expect(user.subscribed_at).to be_nil
    end
  end

  context "password validations" do
    it "allows non-oauth users to update attributes without the password" do
      user = create_user_without_cached_password(admin: false)

      user.admin = true
      user.save

      expect(user.reload).to be_admin
    end

    def create_user_without_cached_password(attributes)
      user = create(:user, attributes)
      User.find(user.id)
    end
  end

  describe "#credit_card" do
    it "returns nil if there is no stripe_customer_id" do
      user = create(:user, stripe_customer_id: "")

      expect(user.credit_card).to be_nil
    end

    it "returns the active card for the stripe customer" do
      user = create(:user, stripe_customer_id: FakeStripe::CUSTOMER_ID)

      expect(user.credit_card).not_to be_nil
      expect(user.credit_card["last4"]).to eq "1234"
    end
  end

  describe "#has_credit_card?" do
    it "returns false if there is no stripe_customer_id" do
      user = build(:user, stripe_customer_id: "")

      expect(user.has_credit_card?).to eq(false)
    end

    it "returns true if there is stripe_customer_id" do
      user = build(:user, stripe_customer_id: "cus_123")

      expect(user.has_credit_card?).to eq(true)
    end
  end

  describe "#plan" do
    context "for a user with an active subscription" do
      it "delegates to the active subscription" do
        user = create(:subscriber)
        expect(user.plan).to eq(user.subscription.plan)
      end
    end

    context "for a user with an inactive subscription" do
      it "returns nil" do
        user = create(:user, :with_inactive_subscription)
        expect(user.plan).to be_nil
      end
    end

    context "for a user without a subscription" do
      it "returns nil" do
        user = create(:user)
        expect(user.plan).to be_nil
      end
    end
  end

  describe "#plan_name" do
    it "delegates to Subscription for the Plan name" do
      user = create(:subscriber)
      expect(user.plan_name).to eq user.subscription.plan.name
    end

    it "returns nil when there is no Subscription" do
      user = create(:user)
      expect(user.plan_name).to be_nil
    end
  end

  describe "#has_access_to?" do
    context "when the user does not have a subscription" do
      it "returns false" do
        user = build_stubbed(:user)

        expect(user).not_to have_access_to(:trails)
      end
    end

    context "when the user has an inactive subscription" do
      it "returns false" do
        user = create(:subscriber)
        allow(user.subscription).to receive(:active?).and_return(false)

        expect(user).not_to have_access_to(:trails)
      end
    end

    context "when the user has an active subscription" do
      it "delegates to the subscription's has_access_to? method" do
        user = create(:subscriber)
        allow(user.subscription).to receive(:has_access_to?).
          and_return("expected")

        expect(user.has_access_to?(:trails)).to eq("expected")
      end
    end

    context "with an inactive subscription and an active team subscription" do
      it "delegates to the team subscription's has_access_to? method" do
        user = create(
          :user,
          :with_inactive_subscription,
          :with_team_subscription
        )

        expect(user.has_access_to?(:trails)).to eq(true)
      end
    end
  end

  describe "#subscription" do
    it "returns a purchased subscription" do
      subscription = build_stubbed(:subscription)
      user = User.new
      allow(user).to receive(:subscription).and_return(subscription)

      expect(user.subscription).to eq(subscription)
    end

    it "returns a team subscription" do
      team = Team.new
      team.subscription = build_stubbed(:subscription)
      user = User.new
      user.team = team

      expect(user.subscription).to eq(team.subscription)
    end

    it "returns the active subscription if there's inactive ones" do
      user = create(:user, :with_inactive_subscription)
      subscription = create(:subscription, user: user)

      expect(user.reload.subscription).to eq(subscription)
    end

    it "returns nil without a subscription" do
      user = User.new

      expect(user.subscription).to be_nil
    end
  end

  describe "#plan" do
    it "delegates to subscription" do
      user = create(:subscriber)
      subscription = user.subscription

      expect(user.plan).to eq subscription.plan
    end

    it "returns nil for user without subscription" do
      user = User.new

      expect(user.plan).to be_nil
    end
  end

  describe "#eligible_for_annual_upgrade?" do
    it "returns true with eligible plan" do
      user = User.new
      subscription = build_stubbed(:subscription)
      allow(user).to receive(:subscription).and_return(subscription)
      subscription.plan.annual_plan = build_stubbed(:plan, :annual)

      expect(user.eligible_for_annual_upgrade?).to be true
    end

    it "returns false with ineligible plan" do
      user = User.new
      subscription = build_stubbed(:subscription)
      allow(user).to receive(:subscription).and_return(subscription)
      subscription.plan.annual_plan = nil

      expect(user.eligible_for_annual_upgrade?).to be false
    end
  end

  describe "#annualized_payment" do
    it "delegates to the user's plan" do
      user = create(:subscriber)

      allow(user.plan).to receive(:annualized_payment).and_return(1234)

      expect(user.annualized_payment).to eq(1234)
    end
  end

  describe "#discounted_annual_payment" do
    it "delegates to the user's plan" do
      user = create(:subscriber)

      allow(user.plan).to receive(:discounted_annual_payment).and_return(1234)

      expect(user.discounted_annual_payment).to eq(1234)
    end
  end

  describe "#annual_plan_sku" do
    it "delegates to the user's plan" do
      user = create(:subscriber)

      allow(user.plan).to receive(:annual_plan_sku).
        and_return("professional-yearly")

      expect(user.annual_plan_sku).to eq("professional-yearly")
    end
  end
end
