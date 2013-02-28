class Unsubscriber
  def initialize(subscription)
    @subscription = subscription
  end

  def process
    Subscription.transaction do
      @subscription.destroy
      stripe_user = Stripe::Customer.retrieve(@subscription.stripe_customer)
      stripe_user.cancel_subscription
    end
  end
end
