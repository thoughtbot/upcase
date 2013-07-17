module Payments
  # Represents a one-time payment with a zero price, which does not actually
  # need to be placed.
  #
  # This is a NullObject to reduce conditional logic when placing purchases.
  class FreePayment
    def initialize(purchase)
    end

    def place
      true
    end

    def update_user(user)
    end

    def refund
    end
  end
end
