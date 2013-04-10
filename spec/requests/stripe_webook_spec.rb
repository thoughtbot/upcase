require 'spec_helper'

describe 'successful charges reported by Stripe webhook' do
  it 'sends the event to Kissmetrics' do
    create(:subscribeable_product, sku: 'prime')

    simulate_stripe_webhook_firing

    kissmetrics_should_receive_succesful_charge_event
  end

  def simulate_stripe_webhook_firing
    post '/stripe-webhook', 'id' => FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
  end

  def kissmetrics_should_receive_succesful_charge_event
    expect(FakeKissmetrics.events_for(FakeStripe::CUSTOMER_EMAIL)).to be_present
  end
end
