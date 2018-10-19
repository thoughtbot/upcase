require "rails_helper"

describe "teams/_team.html.erb" do
  context "when user is team owner" do
    it "renders link to manage users" do
      team = build_stubbed(:team)
      current_user = team.owner

      render "teams/team", current_user: current_user, team: team

      expect(rendered).to include "Manage Users"
    end
  end

  context "when user is not team owner" do
    it "renders instructions to contact team owner" do
      team = build_stubbed(:team)
      owner = build_stubbed(:user)
      expect(team).to receive(:owner).and_return(owner).at_least(:once)
      current_user = build_stubbed(:user)

      render "teams/team", current_user: current_user, team: team

      expect(rendered).to include "Your team owner"
      expect(rendered).to include "can make changes"
    end
  end
end
