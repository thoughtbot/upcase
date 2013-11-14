module Payments
  # Represents a payment placed using Stripe.
  #
  # Placing a Stripe payment immediately charges the credit card. Stripe
  # payments do not need to be completed.
  class StripePayment
    def initialize(purchase)
      @purchase = purchase
    end

    def place
      rescue_stripe_exception do
        ensure_customer_exists
        create_charge_or_subscription
        set_as_paid
      end
    end

    def update_user(user)
      user.update_column :stripe_customer_id, @purchase.stripe_customer_id
    end

    def refund
      charge = Stripe::Charge.retrieve(@purchase.payment_transaction_id)
      if charge && !charge.refunded
        charge.refund(amount: price_in_pennies)
      end
    end

    private

    def rescue_stripe_exception
      yield
      true
    rescue Stripe::StripeError => exception
      @purchase.errors[:base] <<
        'There was a problem processing your credit card, ' +
          exception.message.downcase
      false
    end

    def ensure_customer_exists
      unless customer_exists?
        create_customer
      end
    end

    def create_charge_or_subscription
      if subscription?
        update_subscription
      else
        charge_customer
      end
    end

    def set_as_paid
      @purchase.set_as_paid
    end

    def customer_exists?
      @purchase.stripe_customer_id.present?
    end

    def create_customer
      new_stripe_customer = Stripe::Customer.create(
        card: @purchase.stripe_token,
        description: @purchase.email,
        email: @purchase.email
      )
      @purchase.stripe_customer_id = new_stripe_customer.id
    end

    def subscription?
      @purchase.subscription?
    end

    def update_subscription
      stripe_customer.update_subscription(subscription_attributes)
    end

    def subscription_attributes
      base_subscription_attributes.merge(coupon_attributes)
    end

    def base_subscription_attributes
      {
        plan: @purchase.purchaseable_sku,
        quantity: @purchase.quantity
      }
    end

    def coupon_attributes
      if @purchase.stripe_coupon_id.present?
        { coupon: @purchase.stripe_coupon_id }
      else
        {}
      end
    end

    def charge_customer
      charge = Stripe::Charge.create(
        amount: price_in_pennies,
        currency: 'usd',
        customer: @purchase.stripe_customer_id,
        description: @purchase.purchaseable_name
      )
      @purchase.payment_transaction_id = charge.id
    end

    def stripe_customer
      @stripe_customer ||=
        Stripe::Customer.retrieve(@purchase.stripe_customer_id)
    end

    def price_in_pennies
      (@purchase.price * 100).to_i
    end
  end
end
