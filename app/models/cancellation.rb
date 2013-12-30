class Cancellation
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

  def can_downgrade_instead?
    !downgraded?
  end

  def downgrade_plan
    IndividualPlan.basic
  end

  def subscribed_plan
    @subscription.plan
  end

  def downgrade
    @subscription.change_plan(IndividualPlan.basic)
  end

  private

  def deliver_unsubscription_survey
    SubscriptionMailer.cancellation_survey(@subscription.user).deliver
  end

  def record_scheduled_cancellation_date(stripe_customer)
    @subscription.update_column(
      :scheduled_for_cancellation_on,
      Time.zone.at(stripe_customer.subscription.current_period_end)
    )
  end

  def downgraded?
    @subscription.plan == downgrade_plan
  end
end
