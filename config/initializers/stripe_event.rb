StripeEvent.setup do
  subscribe 'invoice.payment_succeeded' do |event|
    subscription_plan = event.data.object.lines.subscriptions.first.plan

    if Product.find_by_sku(subscription_plan.id).subscription?
      invoice = SubscriptionInvoice.new(event.data.object)

      Mailer.delay.subscription_receipt(
        invoice.user.email,
        invoice.subscription_item_name,
        invoice.amount_paid,
        invoice.stripe_invoice_id
      )

      event_notifier = KissmetricsEventNotifier.new
      event_notifier.notify_of_subscription_billing(
        invoice.user.email,
        invoice.amount_paid
      )
    end
  end

  subscribe 'customer.subscription.deleted' do |event|
    stripe_customer_id = event.data.object.customer

    if user = User.find_by_stripe_customer_id(stripe_customer_id)
      unsubscriber = Unsubscriber.new(user.subscription)
      unsubscriber.process
    end
  end
end
