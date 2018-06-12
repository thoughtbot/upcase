class SendCheckoutReceiptEmailJob < ApplicationJob
  include ErrorReporting

  def perform(checkout_id)
    checkout = Checkout.find(checkout_id)
    CheckoutMailer.receipt(checkout).deliver_now
  end
end
