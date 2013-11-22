require 'spec_helper'

describe SubscriptionAmountUpdater do
  it 'updates the next_payment_amount for the given subscriptions' do
    stripe_invoice = stub_stripe_invoice_with_total(10)
    subscription = create(:subscription)
    subscriptions = [subscription]

    SubscriptionAmountUpdater.new(subscriptions).process

    expect(Stripe::Invoice).
      to have_received(:upcoming).
      with(customer: subscription.stripe_customer_id)
    expect(stripe_invoice).to have_received(:total)
    expect(subscription.reload.next_payment_amount).to eq 10
  end

  it 'sets the next_payment_amount to 0 when it is 404' do
    Stripe::Invoice.stubs(:upcoming).raises(
      Stripe::InvalidRequestError.new('No upcoming invoices for customer', '', 404)
    )
    subscription = create(:subscription)
    subscriptions = [subscription]

    SubscriptionAmountUpdater.new(subscriptions).process

    expect(subscription.reload.next_payment_amount).to eq 0
  end

  it "sends the error to Airbrake if it isn't 404" do
    Airbrake.stubs(:notify)
    error = Stripe::InvalidRequestError.new('Server error', '', 500)
    Stripe::Invoice.stubs(:upcoming).raises(
      error
    )
    subscription = create(:subscription)
    subscriptions = [subscription]

    SubscriptionAmountUpdater.new(subscriptions).process

    expect(Airbrake).to have_received(:notify).with(error)
  end

  private

  def stub_stripe_invoice_with_total(amount)
    stripe_invoice = stub(total: amount)
    Stripe::Invoice.stubs(upcoming: stripe_invoice)
    stripe_invoice
  end
end
