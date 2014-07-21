class SendCheckoutReceiptEmailJob < Struct.new(:checkout_id)
  include ErrorReporting

  def self.enqueue(purchase_id)
    Delayed::Job.enqueue(new(purchase_id))
  end

  def perform
    checkout = Checkout.find(checkout_id)
    CheckoutMailer.receipt(checkout).deliver
  end
end
