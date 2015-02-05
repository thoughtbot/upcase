require "rails_helper"

describe "annual_billings/_annual_savings.html.erb" do
  context "when a team considers signing up for annual billing" do
    it "renders how much the team will save considering team members count" do
      user = build_stubbed(:user, :with_team_subscription)
      allow(user.plan).to receive(:discounted_annual_payment).and_return(990)
      team = user.team
      allow(team).to receive(:users_count).and_return(2)

      render "annual_billings/annual_savings", current_user: user, team: team

      expect(rendered).to include("For 2 team members, you save:")
      expect(rendered).to include("$156") # (1068 - 990) * 2
      expect(rendered).to include("per year")
    end
  end
end
