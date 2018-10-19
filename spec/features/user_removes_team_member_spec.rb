require "rails_helper"
include ActionView::RecordIdentifier

feature "Remove team members" do
  scenario "an owner removes a team member" do
    owner = create(:user, :with_attached_team)
    owner.team.update(owner: owner)
    user_to_remove = create(:user, :with_github)
    add_user_to_team(user_to_remove, owner.team)

    visit my_account_path(as: owner)
    click_link "Manage Users"

    expect(page).to have_css("ul.members li", count: 2)

    click_link dom_id(user_to_remove, "remove")

    expect(page).to have_css("ul.members li", count: 1)
    expect(page).to have_content("#{user_to_remove.name} has been removed")
  end
end
