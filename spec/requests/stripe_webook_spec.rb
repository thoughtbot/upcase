require 'spec_helper'

describe 'successful charges reported by Stripe webhook' do
  it 'sends the event to Kissmetrics' do
    ActionMailer::Base.deliveries.clear
    user = create(
      :user,
      :with_subscription,
      stripe_customer_id: FakeStripe::CUSTOMER_ID
    )
    create(:subscribeable_product, sku: 'prime')

    simulate_stripe_webhook_firing

    kissmetrics_should_receive_succesful_charge_event(user)
  end

  it 'sends the customer a receipt' do
    ActionMailer::Base.deliveries.clear
    user = create(
      :user,
      :with_subscription,
      stripe_customer_id: FakeStripe::CUSTOMER_ID
    )
    create(:subscribeable_product, sku: 'prime')

    simulate_stripe_webhook_firing

    customer_should_receive_receipt_email(user)
  end

  def simulate_stripe_webhook_firing
    post '/stripe-webhook', 'id' => FakeStripe::EVENT_ID_FOR_SUCCESSFUL_INVOICE_PAYMENT
  end

  def kissmetrics_should_receive_succesful_charge_event(user)
    expect(FakeKissmetrics.events_for(user.email)).to be_present
  end

  def customer_should_receive_receipt_email(user)
    email = ActionMailer::Base.deliveries.first
    email.subject.should include('receipt')
    email.to.should eq [user.email]
  end
end
