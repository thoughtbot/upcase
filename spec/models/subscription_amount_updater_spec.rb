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

  private

  def stub_stripe_invoice_with_total(amount)
    stripe_invoice = stub(total: amount)
    Stripe::Invoice.stubs(upcoming: stripe_invoice)
    stripe_invoice
  end
end
