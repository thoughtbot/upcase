class InvoiceNotifier
  def initialize(invoice)
    @invoice = invoice
  end

  def send_receipt
    if invoice_has_a_user?
      email_receipt
    else
      notify_airbrake_of_missing_user
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
      invoice.subscription_item_name,
      invoice.amount_paid,
      invoice.stripe_invoice_id
    )
  end

  def notify_airbrake_of_missing_user
    Airbrake.notify_or_ignore({
      error_message: 'No matching user for Stripe Customer ID',
      error_class: 'StripeEvent',
      parameters: invoice_debugging_information
    })
  end

  def invoice_debugging_information
    {
      stripe_invoice: invoice.stripe_invoice,
      invoice_in_payment_processor: invoice
    }
  end
end
