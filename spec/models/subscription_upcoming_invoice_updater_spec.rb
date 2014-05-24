require 'spec_helper'

describe SubscriptionUpcomingInvoiceUpdater do
  it 'updates the next_payment_amount and next_payment_on for the given subscriptions' do
    stripe_invoice = stub_stripe_invoice_with_total(10)
    subscription = create(:subscription)
    subscriptions = [subscription]

    SubscriptionUpcomingInvoiceUpdater.new(subscriptions).process

    subscription.reload
    expect(Stripe::Invoice).
      to have_received(:upcoming).
      with(customer: subscription.stripe_customer_id)
    expect(stripe_invoice).to have_received(:total)
    expect(subscription.next_payment_amount).to eq 10
    expect(subscription.next_payment_on).to eq Date.parse('2013-12-25')
  end

  it 'sets the next_payment_amount to 0 when it is 404' do
    Stripe::Invoice.stubs(:upcoming).raises(
      Stripe::InvalidRequestError.new('No upcoming invoices for customer', '', 404)
    )
    subscription = create(:subscription)
    subscriptions = [subscription]

    SubscriptionUpcomingInvoiceUpdater.new(subscriptions).process

    subscription.reload
    expect(subscription.next_payment_amount).to eq 0
    expect(subscription.next_payment_on).to be_nil
  end

  it "sends the error to Airbrake if it isn't 404" do
    Airbrake.stubs(:notify)
    error = Stripe::InvalidRequestError.new('Server error', '', 500)
    Stripe::Invoice.stubs(:upcoming).raises(
      error
    )
    subscription = create(:subscription)
    subscriptions = [subscription]

    SubscriptionUpcomingInvoiceUpdater.new(subscriptions).process

    expect(Airbrake).to have_received(:notify).with(error)
  end

  private

  def stub_stripe_invoice_with_total(amount)
    stripe_invoice = double(total: amount, period_end: 1387929600)
    Stripe::Invoice.stubs(upcoming: stripe_invoice)
    stripe_invoice
  end
end
