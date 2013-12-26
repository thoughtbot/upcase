require 'spec_helper'

describe 'successful charges are reported by Stripe webhook' do
  it 'calls InvoicePaymentProcessor to send a receipt notifications' do
    InvoicePaymentProcessor.stubs(:send_receipt_and_notify_of_subscription_billing)
    create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)
    create(:plan, sku: 'prime')

    simulate_stripe_webhook_firing

    expect(InvoicePaymentProcessor).to have_received(:send_receipt_and_notify_of_subscription_billing)
  end

  def simulate_stripe_webhook_firing
    post '/stripe-webhook', 'id' => FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
  end
end

describe 'subscription cancellations reported by Stripe webhook' do
  it 'deactivates the subscription' do
    user = create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

    simulate_stripe_webhook_firing

    expect(user).not_to have_active_subscription
  end

  def simulate_stripe_webhook_firing
    post '/stripe-webhook', 'id' => FakeStripe::EVENT_ID_FOR_SUBSCRIPTION_DELETION
  end
end
