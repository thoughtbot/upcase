module Subscriptions
  def sign_in_as_user_with_subscription
    @current_user = create(
      :subscriber,
      stripe_customer_id: FakeStripe::CUSTOMER_ID
    )
    visit dashboard_path(as: @current_user)
  end

  def sign_in_as_user_with_downgraded_subscription
    sign_in_as_user_with_subscription
    @current_user.subscription.change_plan(create(:downgraded_plan))
  end

  def click_landing_page_call_to_action
    click_link I18n.t('subscriptions.join_cta')
  end

  def click_prime_call_to_action_in_header
    click_link 'Prime Membership'
  end

  def create_mentors
    create(:mentor)
  end
end
