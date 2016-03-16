class StripeEvents
  def initialize(event)
    @event = event
  end

  def customer_subscription_deleted
    if subscription
      Cancellation.new(subscription: subscription).process
      track_user_updated(subscription)
    end
  end

  def customer_subscription_updated
    if subscription
      subscription.write_plan(sku: stripe_subscription.plan.id)
      SubscriptionUpcomingInvoiceUpdater.new([subscription]).process
      track_user_updated(subscription)
    end
  end

  private

  def track_user_updated(subscription)
    Analytics.new(subscription.user).track_updated
  end

  def subscription
    if subscription = Subscription.find_by(stripe_id: stripe_subscription.id)
      subscription
    else
      Honeybadger.notify(
        error_message: "No subscription found for #{stripe_subscription.id}",
        error_class: "StripeEvents",
        context: @event.to_hash,
      )
      nil
    end
  end

  def stripe_subscription
    @event.data.object
  end
end
