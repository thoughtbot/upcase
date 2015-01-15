require "rails_helper"

describe "invitations/_additional_charge.html" do
  context "the team will stay under the minimum" do
    it "returns nothing if the team is below the minimum" do
      team = build_stubbed(:team)
      team.stubs(below_minimum_users?: true)

      render "invitations/additional_charge", team: team

      expect(rendered).to_not have_content("bill will be increased")
    end
  end

  context "the team will go above the minimum" do
    it "returns the amount and interval" do
      team = build_stubbed(:team)
      team.stubs(below_minimum_users?: false)
      price = number_to_currency(team.plan.price, precision: 0)
      interval = team.plan.subscription_interval

      render "invitations/additional_charge", team: team

      expect(rendered).to have_content("#{price} / #{interval}")
    end
  end
end
