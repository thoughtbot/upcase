module Subscriptions
  def sign_in_as_user_with_subscription
    @current_user = create(:user, :with_subscription, stripe_customer_id: FakeStripe::CUSTOMER_ID)
    visit products_path(as: @current_user)
  end

  def click_landing_page_call_to_action
    click_link I18n.t('subscriptions.join_cta')
  end

  def click_prime_call_to_action_in_header
    click_link 'Prime Membership'
  end

  def create_mentors
    create(:user, mentor: true)
  end
end
