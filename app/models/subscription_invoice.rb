class SubscriptionInvoice
  attr_reader :stripe_invoice

  def self.find_all_by_stripe_customer_id(stripe_customer_id)
    if stripe_customer_id.present?
      stripe_invoices_for_customer_id(stripe_customer_id).map do |invoice|
        SubscriptionInvoice.new(invoice)
      end
    else
      []
    end
  end

  def initialize(invoice_id_or_invoice_object)
    if invoice_id_or_invoice_object.is_a? String
      @stripe_invoice = retrieve_stripe_invoice(invoice_id_or_invoice_object)
    else
      @stripe_invoice = invoice_id_or_invoice_object
    end
  end

  def stripe_invoice_id
    stripe_invoice.id
  end

  def number
    date.to_s(:invoice)
  end

  def total
    cents_to_dollars(stripe_invoice.total)
  end

  def subtotal
    cents_to_dollars(stripe_invoice.subtotal)
  end

  def paid?
    stripe_invoice.paid
  end

  def balance
    if paid?
      0.00
    else
      amount_due
    end
  end

  def amount_due
    cents_to_dollars(stripe_invoice.amount_due)
  end

  def amount_paid
    if paid?
      amount_due
    else
      0.00
    end
  end

  def date
    convert_stripe_time(stripe_invoice.date)
  end

  def subscription_item_name
    "Subscription to #{subscription.plan.name}"
  end

  def subscription_item_amount
    cents_to_dollars(subscription.amount)
  end

  def discounted?
    stripe_invoice.discount.present?
  end

  def discount_name
    stripe_invoice.discount.coupon.id
  end

  def discount_amount
    cents_to_dollars(stripe_invoice.discount.coupon.amount_off)
  end

  def user_name
    user.name
  end

  def user_organization
    user.organization
  end

  def user_address1
    user.address1
  end

  def user_address2
    user.address2
  end

  def user_city
    user.city
  end

  def user_state
    user.state
  end

  def user_zip_code
    user.zip_code
  end

  def user_country
    user.country
  end

  def user
    @user ||= User.find_by_stripe_customer_id(stripe_invoice.customer)
  end

  def to_partial_path
    "subscriber/invoices/#{self.class.name.underscore}"
  end

  private

  def self.stripe_invoices_for_customer_id(stripe_customer_id)
    Stripe::Invoice.all(customer: stripe_customer_id, count: 100).data
  end

  def retrieve_stripe_invoice(stripe_invoice_id)
    Stripe::Invoice.retrieve(stripe_invoice_id)
  end

  def cents_to_dollars(amount)
    amount / 100.0
  end

  def convert_stripe_time(time)
    Time.at(time)
  end

  def subscription
    stripe_invoice.lines.subscriptions.first
  end
end
