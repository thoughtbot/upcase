require "rails_helper"

describe "teams/_team.html.erb" do
  context "when team has a subscription" do
    it "renders link to manage users" do
      team = build_stubbed(:team)
      current_user = team.subscription.user

      render "teams/team", current_user: current_user, team: team

      expect(rendered).to include "Manage Users"
    end
  end

  context "when team has no subscription" do
    it "renders no subscription message" do
      team = build_stubbed(:team, subscription: nil)
      current_user = build_stubbed(:user)

      render "teams/team", current_user: current_user, team: team

      expect(rendered).to include "Your team currently has no subscription."
    end
  end
end
