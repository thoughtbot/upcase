require "rails_helper"
include ActionView::Helpers::NumberHelper

feature "User edits a team subscription" do
  background do
    create(:plan, :team)
    sign_in
  end

  scenario "a team owner can see invoices and manage team" do
    owner = create(:user, :with_team_subscription)

    visit my_account_path(as: owner)

    expect(page).to have_content "View all invoices"
    expect(page).to have_content "Cancel"

    click_link "Manage Users"
    owner.reload

    expect(page).to have_content(
      owner.subscription.next_payment_on.to_s(:simple)
    )
    expect(page).to have_content(
      number_to_currency(owner.subscription.next_payment_amount / 100)
    )
  end

  scenario "a non-owner can't manage the subscription" do
    sign_in_as create(:user, :with_github)
    team = create(:team)
    add_user_to_team(current_user, team)

    visit my_account_path

    within "#account-sidebar" do
      expect(page).to_not have_content "View all invoices"
      expect(page).to_not have_content "Cancel"
      expect(page).to_not have_content "Manage Users"
    end
  end

  def plan
    Plan.team.first
  end
end
