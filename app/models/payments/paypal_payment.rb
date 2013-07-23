module Payments
  # Represents a payment completed using PayPal.
  #
  # Placing a PayPal payment creates a transaction request that must be
  # subsequently completed.
  class PaypalPayment
    include Rails.application.routes.url_helpers

    def initialize(purchase)
      @purchase = purchase
    end

    def place
      response = express_request.setup(
        payment_request,
        paypal_purchase_url(@purchase, host: self.class.host),
        products_url(host: self.class.host)
      )
      @purchase.set_as_unpaid
      @purchase.paypal_url = response.redirect_uri
    end

    def complete(params)
      response = express_request.checkout!(
        params[:token],
        params[:PayerID],
        payment_request
      )

      @purchase.payment_transaction_id =
        response.payment_info.first.transaction_id
      @purchase.set_as_paid
    end

    def refund
      express_request.refund!(@purchase.payment_transaction_id)
    end

    def update_user(user)
    end

    def self.host
      if defined?(@@host)
        @@host
      else
        ActionMailer::Base.default_url_options[:host]
      end
    end

    def self.host=(host)
      @@host = host
    end

    private

    def payment_request
      Paypal::Payment::Request.new(
        currency_code: :USD,
        amount: @purchase.price,
        description: @purchase.purchaseable_name,
        items: [
          { amount: @purchase.price, description: @purchase.purchaseable_name }
        ]
      )
    end

    def express_request
      Paypal::Express::Request.new(
        username: PAYPAL_USERNAME,
        password: PAYPAL_PASSWORD,
        signature: PAYPAL_SIGNATURE
      )
    end
  end
end
