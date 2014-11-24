class StripeEvents
  def initialize(event)
    @event = event
  end

  def customer_subscription_deleted
    if subscription = find_subscription
      Cancellation.new(subscription).process
    end
  end

  def customer_subscription_updated
    if subscription = find_subscription
      subscription.write_plan(sku: stripe_subscription.plan.id)
      SubscriptionUpcomingInvoiceUpdater.new([subscription]).process
    else
      Airbrake.notify_or_ignore(
        error_message: "No subscription found for #{stripe_subscription.id}",
        error_class: "StripeEvents",
        parameters: @event.to_hash
      )
      nil
    end
  end

  def find_subscription
    Subscription.find_by(stripe_id: stripe_subscription.id)
  end

  def stripe_subscription
    @event.data.object
  end
end
