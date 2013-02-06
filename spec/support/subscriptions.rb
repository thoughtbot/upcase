module Subscriptions
  def sign_in_as_user_with_subscription
    @current_user = create(:user, :with_subscription)
    visit products_path(as: @current_user)
  end
end
