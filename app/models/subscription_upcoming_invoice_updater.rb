class SubscriptionUpcomingInvoiceUpdater
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def process
    @subscriptions.each do |subscription|
      if subscription.stripe_customer_id
        upcoming_invoice = upcoming_invoice_for(subscription.stripe_customer_id)
        update_next_payment_information(subscription, upcoming_invoice)
      end
    end
  end

  private

  def upcoming_invoice_for(stripe_customer_id)
    Stripe::Invoice.upcoming(customer: stripe_customer_id)
  rescue Stripe::APIError => error
    notify_airbrake(error)
    nil
  end

  def update_next_payment_information(subscription, upcoming_invoice)
    if upcoming_invoice
      update_next_payment_information_from_upcoming_invoice(subscription, upcoming_invoice)
    else
      clear_next_payment_information(subscription)
    end
  end

  def update_next_payment_information_from_upcoming_invoice(subscription, upcoming_invoice)
    subscription.update!(
      next_payment_amount: upcoming_invoice.total,
      next_payment_on: Time.zone.at(upcoming_invoice.period_end)
    )
  end

  def clear_next_payment_information(subscription)
    subscription.update!(
      next_payment_amount: 0,
      next_payment_on: nil
    )
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
