require "rails_helper"

feature "View team invitations" do
  scenario "when some have been accepted" do
    owner = create(:user, :with_team_subscription)
    team = owner.team
    add_user_to_team(create(:user), team)
    create_list(:invitation, 2, team: team)
    create_list(:invitation, 2, :accepted, team: team)

    visit my_account_path(as: owner)
    click_link "Manage Users"

    expect(page).to have_css("ul.members li", count: 2)
    expect(page).to have_css("ul.invitations li", count: 2)
  end

  scenario "a non-team owner can't manage the team" do
    sign_in
    add_user_to_team(current_user, create(:team))

    visit my_account_path

    expect(page).to_not have_content "Manage Users"
  end

  scenario "a team owner is marked as the owner" do
    owner = create(:user, :with_team_subscription)

    visit my_account_path(as: owner)
    click_link "Manage Users"

    expect(page).to have_css(".members li.owner", text: owner.name)
  end
end
