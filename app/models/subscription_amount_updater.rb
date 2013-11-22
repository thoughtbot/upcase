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
  rescue Stripe::InvalidRequestError => error
    notify_airbrake(error)
    0
  end

  def next_invoice(stripe_customer_id)
    Stripe::Invoice.upcoming(customer: stripe_customer_id)
  end

  def notify_airbrake(error)
    unless error_is_because_user_has_no_upcoming_invoice?(error)
      Airbrake.notify(error)
    end
  end

  def error_is_because_user_has_no_upcoming_invoice?(error)
    error.http_status == 404
  end
end
