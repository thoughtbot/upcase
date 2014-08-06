require "spec_helper"

feature "View team invitations" do
  scenario "when some have been accepted" do
    using_session :team_member do
      sign_in
      team = create(:team)
      add_user_to_team(current_user, team)
      create_list(:invitation, 2, team: team)
      create_list(:invitation, 2, :accepted, team: team)

      visit teams_invitations_path

      expect(page).to have_css(".accepted", count: 2)
      expect(page).to have_css(".pending", count: 2)
    end
  end

  def add_user_to_team(user, team)
    user.team = team
    user.save!
  end
end
