require "rails_helper"

describe License do
  describe ".for" do
    context "when the user has a subscription" do
      it "returns the subscription for the user" do
        subscription = create(:subscription)

        license = License.for(subscription.user)

        expect(license.subscription_id).to eq subscription.id
      end
    end

    context "when the subscription is deactivated" do
      it "returns the nil" do
        subscription = create(:inactive_subscription)

        license = License.for(subscription.user)

        expect(license).to be_an_instance_of NullLicense
      end
    end

    context "when they have an active subscription through a team" do
      it "returns the team subscription for the user" do
        team = create(:team)
        user = create(:user, team: team)

        license = License.for(user)

        expect(license.subscription_id).to eq team.subscription.id
      end
    end

    context "when they have an inactive subscription through a team" do
      it "returns nil" do
        subscription = create(:inactive_subscription)
        team = create(:team, subscription: subscription)
        user = create(:user, team: team)

        license = License.for(user)

        expect(license).to be_an_instance_of NullLicense
      end
    end
  end

  describe "#owned_by?" do
    it "is true if the user is the subscription owner" do
      subscription = create(:subscription)
      owner = subscription.user

      license = License.for(owner)

      expect(license).to be_owned_by(owner)
    end

    it "is false otherwise" do
      subscription = create(:subscription)
      user = create(:user)

      license = License.for(subscription.user)

      expect(license).not_to be_owned_by(user)
    end
  end

  describe "#eligible_for_annual_upgrade?" do
    it "is true if the associated plan can be upgraded to annual billing" do
      plan = create(:plan, :with_annual_plan)
      subscription = create(:subscription, plan: plan)

      license = License.for(subscription.user)

      expect(license).to be_eligible_for_annual_upgrade
    end

    it "is false if the associated plan cannot be upgraded to annual billing" do
      subscription = create(:subscription)

      license = License.for(subscription.user)

      expect(license).not_to be_eligible_for_annual_upgrade
    end
  end

  describe "#grants_access_to?" do
    it "delegates to the associated plan" do
      plan = create(
        :plan,
        includes_forum: true,
        includes_trails: false,
      )
      subscription = create(:subscription, plan: plan)

      license = License.for(subscription.user)

      expect(license.grants_access_to?(:forum)).to be true
      expect(license.grants_access_to?(:trails)).to be false
    end
  end
end
