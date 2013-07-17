module Payments
  # Builds a payment strategy for the given payment method and purchase.
  class Factory
    def initialize(payment_method)
      @payment_method = payment_method
    end

    def new(purchase)
      payment_class.new(purchase)
    end

    private

    def payment_class
      Payments.const_get(payment_class_name)
    end

    def payment_class_name
      "#{@payment_method.classify}Payment"
    end
  end
end
