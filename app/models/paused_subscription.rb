class PausedSubscription
  PAUSE_DURATION = 90.days

  def initialize(subscription)
    @subscription = subscription
  end

  def schedule
    subscription.update(scheduled_for_reactivation_on: reactivation_date)
    cancel_current_subscription
    track_paused
  end

  def last_billing_date
    Time.zone.at(billing_period_end)
  end

  def reactivation_date
    last_billing_date + PAUSE_DURATION
  end

  protected

  attr_reader :subscription

  private

  def cancel_current_subscription
    Cancellation.new(subscription: subscription).schedule
  end

  def track_paused
    Analytics.new(subscription.user).track_paused
  end

  def billing_period_end
    stripe_customer.
      subscriptions.
      first.
      current_period_end
  end

  def stripe_customer
    @_stripe_customer ||= StripeCustomerFinder.retrieve(stripe_customer_id)
  end

  def stripe_customer_id
    subscription.stripe_customer_id
  end
end
