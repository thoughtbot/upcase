require "rails_helper"

feature "Subscriber upgrades to annual billing" do
  scenario "Successfully" do
    sign_in_as_user_with_subscription
    click_link "Get two months free"

    expect(page.body).to include("$1188")
    expect(page.body).to include("$990")

    click_button "Switch to annual billing"

    expect(page.body).to include("Thanks!")
    expect(last_email.to).to include(ENV["SUPPORT_EMAIL"])
  end

  scenario "user with no subscription doesn't see link" do
    sign_in

    expect_to_not_see_upgrade_link
  end

  scenario "visitor doesn't see link" do
    visit products_url

    expect_to_not_see_upgrade_link
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def expect_to_not_see_upgrade_link
    expect(page).to_not have_content "Get two months free"
  end
end
