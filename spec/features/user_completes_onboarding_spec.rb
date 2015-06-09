require "rails_helper"

feature "User completes onboarding flow" do
  scenario "and is taken to the practice page with a message" do
    subscriber = create(:subscriber, :with_full_subscription, :needs_onboarding)
    visit root_path(as: subscriber)

    expect(page).to have_link("Help")

    click_on I18n.t("pages.welcome.complete-welcome")

    expect(current_path).to eq(practice_path)
  end
end
