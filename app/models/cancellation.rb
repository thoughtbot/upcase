class Cancellation
  include ActiveModel::Model

  attr_accessor :reason

  validates :reason, presence: true

  def initialize(subscription, reason = "")
    @subscription = subscription
    @reason = reason
  end

  def schedule
    if valid?
      cancel_at_period_end
      true
    else
      false
    end
  end

  def cancel_now
    Subscription.transaction do
      stripe_customer.subscriptions.first.delete
      @subscription.deactivate
      track_cancelled
    end
  end

  def cancel_and_refund
    stripe_customer.subscriptions.first.delete
    @subscription.last_charge.try(:refund)
  end

  def process
    if @subscription.active?
      @subscription.deactivate
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
    @subscription.change_plan(sku: Plan.basic.sku)
  end

  private

  def cancel_at_period_end
    Subscription.transaction do
      stripe_customer.subscriptions.first.delete(at_period_end: true)
      record_scheduled_cancellation_date(stripe_customer)
      track_cancelled
    end
  end

  def track_cancelled
    Analytics.new(@subscription.user).track_cancelled(reason)
  end

  def record_scheduled_cancellation_date(stripe_customer)
    @subscription.update_column(
      :scheduled_for_cancellation_on,
      Time.zone.at(stripe_customer.subscriptions.first.current_period_end)
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
