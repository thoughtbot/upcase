class InvoicePaymentProcessor
  def initialize(invoice)
    @invoice = invoice
  end

  def self.send_receipt_and_notify_of_subscription_billing(invoice)
    payment_processor = new(invoice)
    payment_processor.send_receipt
    payment_processor.notify_of_subscription_billing
  end

  def send_receipt
    if invoice_has_a_user?
      SubscriptionMailer.delay.subscription_receipt(
        invoice.user_email,
        invoice.subscription_item_name,
        invoice.amount_paid,
        invoice.stripe_invoice_id
      )
    end
  end

  def notify_of_subscription_billing
    if invoice_has_a_user?
      notify_kissmetrics
    else
      notify_airbrake_of_missing_user
    end
  end

  private

  attr_reader :invoice

  def invoice_has_a_user?
    invoice.user_email.present?
  end

  def notify_kissmetrics
    event_notifier = KissmetricsEventNotifier.new
    event_notifier.notify_of_subscription_billing(
      invoice.user_email,
      invoice.amount_paid
    )
  end

  def notify_airbrake_of_missing_user
    Airbrake.notify_or_ignore({
      error_message: 'No matching user for Stripe Customer ID',
      error_class: 'Stripe',
      parameters: {
        stripe_invoice: invoice.stripe_invoice,
        invoice_in_payment_processor: invoice
      }
    })
  end
end
