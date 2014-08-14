module Subscriptions
  def sign_in_as_user_with_subscription(*traits)
    @current_user = create(
      :subscriber,
      *traits,
      stripe_customer_id: FakeStripe::CUSTOMER_ID
    )
    visit dashboard_path(as: @current_user)
  end

  def sign_in_as_user_with_mentoring_subscription
    sign_in_as_user_with_subscription(:includes_mentor)
  end

  def sign_in_as_user_with_downgraded_subscription
    sign_in_as_user_with_subscription
    @current_user.subscription.change_plan(create(:basic_plan))
  end

  def click_landing_page_call_to_action
    click_link I18n.t("subscriptions.join_cta")
  end

  def click_upcase_call_to_action_in_header
    click_link "Upcase Membership"
  end

  def settings_page
    click_on "Settings"
    page
  end

  def have_subscription_to(plan_name)
    have_css(".subscription", text: plan_name)
  end
end
