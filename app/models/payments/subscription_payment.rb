module Payments
  class SubscriptionPayment
    def initialize(purchase)
      @purchase = purchase
    end

    def place
      @purchase.set_as_paid
      true
    end

    def update_user(user)
    end

    def refund
    end
  end
end
