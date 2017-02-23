require "rails_helper"

feature "User cancels a subscription" do
  scenario "successfully unsubscribes and pauses" do
    create(:discounted_annual_plan)

    sign_in_as_user_with_subscription :with_full_subscription
    visit my_account_path
    click_link I18n.t("subscriptions.cancel")
    click_link I18n.t("subscriptions.pause")

    expect(page).to have_content I18n.t("subscriptions.flashes.pause.success")
    expect(analytics).to have_tracked("Paused")
  end
end
