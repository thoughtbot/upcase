class SubscriptionAmountUpdater
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def process
    @subscriptions.each do |subscription|
      subscription.update!(
        next_payment_amount: next_invoice_total(subscription.stripe_customer_id)
      )
    end
  end

  private

  def next_invoice_total(stripe_customer_id)
    next_invoice(stripe_customer_id).total
  end

  def next_invoice(stripe_customer_id)
    Stripe::Invoice.upcoming(customer: stripe_customer_id)
  end
end
