require "rails_helper"

describe Team do
  it { should belong_to(:subscription) }
  it { should have_many(:users).dependent(:nullify) }
  it { should validate_presence_of(:name) }

  it { should delegate(:plan).to(:subscription) }
  it { should delegate(:owner?).to(:subscription) }

  describe "#owner" do
    it "gets the team owner" do
      team = create(:team)

      expect(team.owner).to eq(team.subscription.user)
    end
  end

  describe "#add_user" do
    it "fulfills that user's subscription" do
      team = create(:team)
      user = create(:user)
      fulfillment = stub_team_fulfillment(team, user)

      team.add_user(user)

      expect(user.reload.team).to eq team
      expect(fulfillment).to have_received(:fulfill)
    end

    it "cancels user's personal subscription" do
      team = create(:team)
      user = create(:subscriber)

      team.add_user(user)

      expect(user.subscriptions.first).not_to be_active
    end

    context "when below the minimum" do
      it "updates the team's subscription quantity with the minimum" do
        team = team_with_stubbed_subscription_change_quantity
        minimum_quantity = team.subscription.plan.minimum_quantity
        user = create(:user, :with_github)

        team.add_user(user)

        expect(team.subscription).
          to have_received(:change_quantity).
          with(minimum_quantity)
      end
    end

    context "#users_count" do
      it "returns the number of team members" do
        team = build_stubbed(:team)
        create_list(:user, 2, team: team)

        expect(team.users_count).to eq(2)
      end
    end

    context "#annualized_savings" do
      it "returns savings gained if moved to yearly plan" do
        user = create(:user, :with_team_subscription)
        user.plan.update(annual_plan: create(:plan, :annual))
        user.reload
        team = user.team
        allow(team).to receive(:users_count).and_return(3)

        expect(team.annualized_savings).to eq(234)
      end
    end

    context "when above the minimum" do
      it "updates the team's subscription with the number of team members" do
        team = team_with_stubbed_subscription_change_quantity
        minimum_quantity = team.subscription.plan.minimum_quantity
        create_list(:user, minimum_quantity, team: team)
        user = create(:user, :with_github)

        team.add_user(user)

        expect(team.subscription).
          to have_received(:change_quantity).
          with(minimum_quantity + 1)
      end
    end
  end

  describe "#remove_user" do
    it "removes that user's subscription" do
      team = create(:team)
      user = create(:user)
      fulfillment = stub_team_fulfillment(team, user)

      team.remove_user(user)

      expect(user.reload.team).to be_nil
      expect(fulfillment).to have_received(:remove)
    end

    context "when below the minimum" do
      it "updates the team's subscription quantity with the minimum" do
        team = team_with_stubbed_subscription_change_quantity
        minimum_quantity = team.subscription.plan.minimum_quantity
        user = create(:user, :with_github, team: team)

        team.remove_user(user)

        expect(team.subscription).
          to have_received(:change_quantity).
          with(minimum_quantity)
      end
    end

    context "when above the minimum" do
      it "updates the team's subscription with the number of team members" do
        team = team_with_stubbed_subscription_change_quantity
        minimum_quantity = team.subscription.plan.minimum_quantity
        create_list(:user, minimum_quantity + 2, team: team)
        user = create(:user, :with_github, team: team)

        team.remove_user(user)

        expect(team.subscription).
          to have_received(:change_quantity).
          with(minimum_quantity + 2)
      end
    end
  end

  describe "#below_minimum_users?" do
    context "the team will stay under the minimum" do
      it "returns nothing if the team is below the minimum" do
        team = create(:team)
        create(:user, team: team)

        expect(team.below_minimum_users?).to be_truthy
      end
    end

    context "the team will go above the minimum" do
      it "returns the amount and interval" do
        team = create(:team)
        create_list(:user, team.subscription.plan.minimum_quantity, team: team)

        expect(team.below_minimum_users?).to be_falsey
      end
    end
  end

  def team_with_stubbed_subscription_change_quantity
    team = create(:team)
    subscription = build_stubbed(:team_subscription)
    allow(subscription).to receive(:change_quantity).and_return(nil)
    allow(team).to receive(:subscription).and_return(subscription)
    team
  end

  def stub_team_fulfillment(team, user)
    checkout = build_stubbed(:checkout, plan: team.subscription.plan)
    stub_subscription_fulfillment(checkout, user)
  end
end
