class Cancellation
  include ActiveModel::Model

  attr_accessor :reason

  def initialize(subscription:, reason: "")
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

  def process
    if @subscription.active?
      @subscription.deactivate
    end
  end

  def subscribed_plan
    @subscription.plan
  end

  private

  def cancel_at_period_end
    Subscription.transaction do
      stripe_customer.subscriptions.first.delete(at_period_end: true)
      record_date_when_subscription_will_deactivate
      record_date_user_clicked_cancel
      track_cancelled
    end
  end

  def track_cancelled
    Analytics.
      new(@subscription.user).
      track_cancelled(reason: reason)
  end

  def record_date_when_subscription_will_deactivate
    @subscription.update_column(
      :scheduled_for_deactivation_on,
      end_of_billing_period,
    )
  end

  def record_date_user_clicked_cancel
    @subscription.update(
      user_clicked_cancel_button_on: Time.zone.today,
    )
  end

  def stripe_customer
    @stripe_customer ||= StripeCustomerFinder.retrieve(stripe_customer_id)
  end

  def stripe_customer_id
    @subscription.stripe_customer_id
  end

  def end_of_billing_period
    Time.zone.at(stripe_customer.subscriptions.first.current_period_end)
  end
end
