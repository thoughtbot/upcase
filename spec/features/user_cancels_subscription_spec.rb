require "rails_helper"

feature "User cancels a subscription" do
  scenario "successfully unsubscribes without a refund" do
    create(:plan, name: "Upcase")
    create(:basic_plan)
    create(:video_tutorial, name: "A Cool VideoTutorial")

    sign_in_as_user_with_subscription

    expect(@current_user).to have_active_subscription

    visit my_account_path
    click_link I18n.t("subscriptions.cancel")

    expect_to_see_alternate_offer

    fill_in "cancellation_reason", with: "I didn't like it"
    click_button I18n.t("subscriptions.confirm_cancel_reject_deal")

    expect(page).to have_content I18n.t("subscriptions.flashes.cancel.success")
    expect(analytics).to(
      have_tracked("Cancelled").
      for_user(@current_user).
      with_properties(reason: "I didn't like it")
    )
  end

  scenario "without a reason" do
    create(:plan, name: "Upcase")
    create(:basic_plan)
    create(:video_tutorial, name: "A Cool VideoTutorial")

    sign_in_as_user_with_subscription

    expect(@current_user).to have_active_subscription

    visit my_account_path
    click_link I18n.t("subscriptions.cancel")

    expect_to_see_alternate_offer

    click_button I18n.t("subscriptions.confirm_cancel_reject_deal")

    expect(page).to have_content("can't be blank")
    expect(analytics).not_to(
      have_tracked("Cancelled").
      for_user(@current_user)
    )
  end

  def expect_to_see_alternate_offer
    expect(page).to have_content "make sure you know about the option to switch"
  end
end
