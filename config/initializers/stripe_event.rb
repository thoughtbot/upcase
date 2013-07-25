StripeEvent.setup do
  subscribe 'invoice.payment_succeeded' do |event|
    subscription_plan = event.data.object.lines.subscriptions.first.plan

    if Plan.where(sku: subscription_plan.id).first
      invoice = SubscriptionInvoice.new(event.data.object)

      SubscriptionMailer.delay.subscription_receipt(
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
      cancellation = Cancellation.new(user.subscription)
      cancellation.process
    end
  end
end
