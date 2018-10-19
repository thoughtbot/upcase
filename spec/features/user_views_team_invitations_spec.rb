require "rails_helper"

feature "View team invitations" do
  scenario "when some have been accepted" do
    owner = create(:user, :with_attached_team)
    team = owner.team
    add_user_to_team(create(:user, :with_github), team)
    create_list(:invitation, 2, team: team)
    create_list(:invitation, 2, :accepted, team: team)

    visit my_account_path(as: owner)
    click_link "Manage Users"

    expect(page).to have_css("ul.members li", count: 2)
    expect(page).to have_css("ul.invitations li", count: 2)
  end

  scenario "a non-team owner can't manage the team" do
    owner = create(:user, :with_attached_team)
    sign_in_as create(:user, :with_github)
    add_user_to_team(current_user, owner.team)

    visit my_account_path

    expect(page).to_not have_content "Manage Users"
  end

  scenario "a team owner is marked as the owner" do
    owner = create(:user, :with_attached_team)

    visit my_account_path(as: owner)
    click_link "Manage Users"

    expect(page).to have_css(".members li.owner", text: owner.name)
  end
end
