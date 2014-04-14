# Finds and wraps Stripe's Invoice object with convenience methods
class Invoice
  attr_reader :stripe_invoice

  delegate :name, :organization, :address1, :address2, :city, :state, :zip_code, :country, :email,
     to: :user, prefix: true

  def self.find_all_by_stripe_customer_id(stripe_customer_id)
    if stripe_customer_id.present?
      stripe_invoices_for_customer_id(stripe_customer_id).map do |invoice|
        new(invoice)
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

  def discounted?
    stripe_invoice.discount.present?
  end

  def discount_name
    stripe_invoice.discount.coupon.id
  end

  def discount_amount
    cents_to_dollars(stripe_invoice.subtotal - stripe_invoice.total)
  end

  def user
    @user ||= User.find_by(stripe_customer_id: stripe_invoice.customer)
  end

  def to_partial_path
    "subscriber/invoices/#{self.class.name.underscore}"
  end

  def line_items
    stripe_line_items.map { |stripe_line_item| LineItem.new(stripe_line_item) }
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
    Time.zone.at(time)
  end

  def stripe_line_items
    stripe_invoice.lines.invoiceitems +
    stripe_invoice.lines.prorations +
    stripe_invoice.lines.subscriptions
  end
end
