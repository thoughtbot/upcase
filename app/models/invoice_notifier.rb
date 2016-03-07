class InvoiceNotifier
  def initialize(invoice)
    @invoice = invoice
  end

  def send_receipt
    if invoice_has_a_user?
      email_receipt
    else
      notify_honeybadger_of_missing_user
    end
  end

  private

  attr_reader :invoice

  def invoice_has_a_user?
    invoice.user.present?
  end

  def email_receipt
    SubscriptionMailer.delay.subscription_receipt(
      invoice.user_email,
      invoice.amount_paid,
      invoice.stripe_invoice_id
    )
  end

  def notify_honeybadger_of_missing_user
    Honeybadger.notify(
      error_message: 'No matching user for Stripe Customer ID',
      error_class: 'StripeEvent',
      context: invoice_debugging_information,
    )
  end

  def invoice_debugging_information
    {
      stripe_invoice: invoice.stripe_invoice,
      invoice_in_payment_processor: invoice
    }
  end
end
