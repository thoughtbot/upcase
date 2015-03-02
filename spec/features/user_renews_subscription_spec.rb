require "rails_helper"

feature "User renews a subscription" do
  scenario "when already deactivated" do
    create(:trail, :published)
    create(:basic_plan)
    user = create(:user, :with_inactive_subscription)

    sign_in_as user
    visit join_path
    click_link "Start Learning"

    fill_out_credit_card_form_with_valid_credit_card
    expect(user.subscriptions.count).to eq 2
  end

  scenario "when scheduled_for_cancellation_on but not deactivated yet" do
    create(:trail, :published)
    create(:basic_plan)
    user = create(:subscriber)
    Cancellation.new(user.subscription, "reason").schedule

    sign_in_as user
    visit new_checkout_path(plan: user.plan)
    click_link "Start learning"

    expect(page).to have_content(I18n.t("subscriptions.flashes.change.success"))
    expect(user.subscriptions.count).to eq 1

    visit "/my_account"
    expect(page).to have_no_content("Scheduled for cancellation on")
  end
end
