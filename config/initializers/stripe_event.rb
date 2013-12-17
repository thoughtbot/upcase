# Handlers for Stripe's webhook.
StripeEvent.setup do
  subscribe 'invoice.payment_succeeded' do |event|
    invoice = SubscriptionInvoice.new(event.data.object)
    InvoiceNotifier.new(invoice).send_receipt
  end

  subscribe 'customer.subscription.deleted' do |event|
    stripe_customer_id = event.data.object.customer

    if user = User.find_by_stripe_customer_id(stripe_customer_id)
      cancellation = Cancellation.new(user.subscription)
      cancellation.process
    end
  end
end
