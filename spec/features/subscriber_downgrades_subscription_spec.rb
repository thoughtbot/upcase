require "rails_helper"

feature "Subscriber switches to discounted subscription" do
  scenario "by accepting alternate offer" do
    discounted_annual_plan = create(:discounted_annual_plan)

    sign_in_as_user_with_subscription
    visit my_account_path
    click_link I18n.t("subscriptions.cancel")
    click_button I18n.t("subscriptions.accept_discounted_annual_subscription")

    expect(page).to(
      have_content(I18n.t("subscriptions.flashes.discount.success"))
    )
    expect(@current_user.reload.plan).to eq discounted_annual_plan
  end
end
