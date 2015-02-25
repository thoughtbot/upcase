class SendCheckoutReceiptEmailJob < Struct.new(:checkout_id)
  include ErrorReporting

  def self.enqueue(checkout_id)
    Delayed::Job.enqueue(new(checkout_id))
  end

  def perform
    checkout = Checkout.find(checkout_id)

    CheckoutMailer.receipt(checkout.user_email, checkout.plan_id).deliver_now
  end
end
