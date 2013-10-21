StripeEvent.setup do
  subscribe 'invoice.payment_succeeded' do |event|
    subscription_plan = event.data.object.lines.subscriptions.first.plan

    if PlanFinder.where(sku: subscription_plan.id).first
      paid_invoice = SubscriptionInvoice.new(event.data.object)
      InvoicePaymentProcessor.send_receipt_and_notify_of_subscription_billing(paid_invoice)
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
