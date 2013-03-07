class ViewableSubscription
  include Rails.application.routes.url_helpers

  def initialize(user, subscription)
    @user = user
    @subscription = subscription
  end

  def should_display_subscription_cta?(current_path)
    if @user
      user_has_not_subscribed_already? && not_currently_viewing_subscription?(current_path)
    end
  end

  def to_param
    @subscription.to_param
  end

  private

  def user_has_not_subscribed_already?
    !@user.has_active_subscription?
  end

  def not_currently_viewing_subscription?(current_path)
    current_path != product_path(@subscription)
  end
end
