module Subscriptions
  def sign_in_as_user_with_subscription
    @current_user = create(:user, :with_subscription, stripe_customer_id: FakeStripe::CUSTOMER_ID)
    visit products_path(as: @current_user)
  end
end
