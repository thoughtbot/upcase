class Unsubscriber
  def initialize(subscription)
    @subscription = subscription
  end

  def schedule
    Subscription.transaction do
      stripe_customer = Stripe::Customer.retrieve(@subscription.stripe_customer_id)
      stripe_customer.cancel_subscription(at_period_end: true)
      record_scheduled_cancellation_date(stripe_customer)
    end
  end

  def process
    @subscription.deactivate
    deliver_unsubscription_survey
  end

  private

  def deliver_unsubscription_survey
    Mailer.unsubscription_survey(@subscription.user).deliver
  end

  def record_scheduled_cancellation_date(stripe_customer)
    @subscription.update_column(
      :scheduled_for_cancelation_on,
      Time.at(stripe_customer.subscription.current_period_end)
    )
  end
end
