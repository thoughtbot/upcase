StripeEvent.setup do
  subscribe 'invoice.payment_succeeded' do |event|
    subscription_plan = event.data.object.lines.subscriptions.first.plan

    if Product.find_by_sku(subscription_plan.id).subscription?
      stripe_customer_id = event.data.object.customer
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      billed_amount = subscription_plan.amount / 100.0

      event_notifier = KissmetricsEventNotifier.new
      event_notifier.notify_of_subscription_billing(customer.email, billed_amount)
    end
  end
end
