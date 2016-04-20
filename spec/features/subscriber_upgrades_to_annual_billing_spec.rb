require "rails_helper"

feature "Subscriber upgrades to annual billing" do
  scenario "Successfully" do
    sign_in_as_user_with_subscription_that_is_eligible_for_annual_upgrade
    click_link "Get two months free"

    expect(page.body).to include("$1188")
    expect(page.body).to include("$990")

    click_button "Switch to annual billing"

    annual_plan = Plan.find_by(annual: true)
    expect(page.body).to include(I18n.t("subscriptions.flashes.change.success"))
    expect(page.body).to include(annual_plan.name)
  end

  scenario "user with no subscription doesn't see link" do
    sign_in

    expect_to_not_see_upgrade_link
  end

  scenario "visitor doesn't see link" do
    create(:plan)
    visit root_path

    expect_to_not_see_upgrade_link
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def expect_to_not_see_upgrade_link
    expect(page).to_not have_content "Get two months free"
  end
end
