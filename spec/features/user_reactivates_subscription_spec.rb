require "rails_helper"

feature "User reactivates subscription" do
  scenario "after canceling, but before the grace period ends" do
    sign_in_as_user_with_subscription
    @current_user.subscription.update!(scheduled_for_deactivation_on: 1.month.from_now)
    visit my_account_path

    click_on I18n.t("subscriptions.reactivate")

    expect(page).to have_content(I18n.t("subscriptions.flashes.reactivate.success"))
  end
end
