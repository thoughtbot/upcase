require "rails_helper"

feature "User cancels a subscription" do
  scenario "successfully unsubscribes without a refund" do
    create(:discounted_annual_plan)

    sign_in_as_user_with_subscription :with_full_subscription

    expect(@current_user.subscriber?).to eq(true)

    visit my_account_path
    click_link I18n.t("subscriptions.cancel")
    fill_in "cancellation_reason", with: "I didn't like it"
    click_button I18n.t("subscriptions.confirm_cancel")

    expect(page).to have_content I18n.t("subscriptions.flashes.cancel.success")
    expect(analytics).to(
      have_tracked("Cancelled").
      with_properties(reason: "I didn't like it"),
    )
  end
end
