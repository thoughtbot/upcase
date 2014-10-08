class Cancellation
  def initialize(subscription)
    @subscription = subscription
  end

  def schedule
    Subscription.transaction do
      stripe_customer.cancel_subscription(at_period_end: true)
      schedule_cancellation_and_clear_next_payment_date(stripe_customer)
      track_cancelled
    end
  end

  def cancel_and_refund
    stripe_customer.cancel_subscription(at_period_end: false)
    @subscription.last_charge.try(:refund)
  end

  def process
    if @subscription.active?
      @subscription.deactivate
      deliver_unsubscription_survey
    end
  end

  def can_downgrade_instead?
    !downgraded?
  end

  def downgrade_plan
    Plan.basic
  end

  def subscribed_plan
    @subscription.plan
  end

  def downgrade
    @subscription.change_plan(Plan.basic)
  end

  private

  def track_cancelled
    Analytics.new(@subscription.user).track_cancelled
  end

  def deliver_unsubscription_survey
    SubscriptionMailer.cancellation_survey(@subscription.user).deliver
  end

  def schedule_cancellation_and_clear_next_payment_date(stripe_customer)
    @subscription.update(
      next_payment_on: nil,
      scheduled_for_cancellation_on:
        Time.zone.at(stripe_customer.subscription.current_period_end),
    )
  end

  def downgraded?
    @subscription.plan == downgrade_plan
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
  end

  def stripe_customer_id
    @subscription.stripe_customer_id
  end
end
