require "rails_helper"
include ActionView::Helpers::NumberHelper

feature "User edits a team" do
  background do
    sign_in
  end

  scenario "a team owner can manage team" do
    owner = create(:user, :with_attached_team)

    visit my_account_path(as: owner)

    click_link "Manage Users"
    owner.reload
  end

  scenario "a non-owner can't manage the team" do
    owner = create(:user, :with_attached_team)
    sign_in_as create(:user, :with_github)
    add_user_to_team(current_user, owner.team)

    visit my_account_path

    within "#account-sidebar" do
      expect(page).to_not have_content "Cancel"
      expect(page).to_not have_content "Manage Users"
    end
  end
end
