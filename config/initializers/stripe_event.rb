# Handlers for Stripe's webhook.
StripeEvent.setup do
  subscribe "invoice.payment_succeeded" do |event|
    invoice = Invoice.new(event.data.object)
    InvoiceNotifier.new(invoice).send_receipt
  end

  subscribe "customer.subscription.updated" do |event|
    StripeEvents.new(event).customer_subscription_updated
  end

  subscribe "customer.subscription.deleted" do |event|
    StripeEvents.new(event).customer_subscription_deleted
  end
end
