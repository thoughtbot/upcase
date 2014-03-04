require 'spec_helper'

describe 'successful charges are reported by Stripe webhook' do
  it 'calls InvoicePaymentProcessor to send a receipt notifications' do
    invoice_notifier = stub('invoice_notifier')
    invoice_notifier.stubs(:send_receipt)
    InvoiceNotifier.stubs(:new).returns(invoice_notifier)
    create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)
    create(:plan, sku: 'prime')

    simulate_stripe_webhook_firing

    expect(invoice_notifier).to have_received(:send_receipt)
  end

  def simulate_stripe_webhook_firing
    post '/stripe-webhook', 'id' => FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
  end
end

describe 'successful payments for a user who can cancelled earlier in the billing period' do
  it 'does not error' do
    post(
      '/stripe-webhook',
      'id' => FakeStripe::EVENT_ID_FOR_INVOICE_PAYMENT_FOR_UNSUBSCRIBED_USER
    )

    expect(response).to be_success
  end
end

describe 'subscription cancellations reported by Stripe webhook' do
  it 'deactivates the subscription' do
    user = create(:subscriber, stripe_customer_id: FakeStripe::CUSTOMER_ID)

    simulate_stripe_webhook_firing

    expect(user.reload).not_to have_active_subscription
  end

  def simulate_stripe_webhook_firing
    post '/stripe-webhook', 'id' => FakeStripe::EVENT_ID_FOR_SUBSCRIPTION_DELETION
  end
end
