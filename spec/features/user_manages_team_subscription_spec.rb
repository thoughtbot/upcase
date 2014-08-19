require "rails_helper"

feature "User edits a team subscription" do
  background do
    create(:team_plan)
    sign_in
  end

  scenario "a team owner can manage the subscription" do
    owner = create(:user, :with_team_subscription)

    visit my_account_path(as: owner)

    expect(page).to have_content "Change plan"
    expect(page).to have_content "View all invoices"
    expect(page).to have_content "Cancel"
  end

  scenario "a non-owner can't manage the subscription" do
    sign_in
    team = create(:team)
    add_user_to_team(current_user, team)

    visit my_account_path

    expect(page).to_not have_content "Change plan"
    expect(page).to_not have_content "View all invoices"
    expect(page).to_not have_content "Cancel"
  end
end
