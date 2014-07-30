class StripeSubscription
  def initialize(checkout)
    @checkout = checkout
  end

  def create
    rescue_stripe_exception do
      ensure_customer_exists
      update_subscription
    end
  end

  def update_user(user)
    user.update_column :stripe_customer_id, @checkout.stripe_customer_id
  end

  private

  def rescue_stripe_exception
    yield
    true
  rescue Stripe::StripeError => exception
    @checkout.errors[:base] <<
      'There was a problem processing your credit card, ' +
        exception.message.downcase
    false
  end

  def ensure_customer_exists
    unless customer_exists?
      create_customer
    end
  end

  def customer_exists?
    @checkout.stripe_customer_id.present?
  end

  def create_customer
    new_stripe_customer = Stripe::Customer.create(
      card: @checkout.stripe_token,
      description: @checkout.email,
      email: @checkout.email
    )
    @checkout.stripe_customer_id = new_stripe_customer.id
  end

  def update_subscription
    stripe_customer.update_subscription(subscription_attributes)
  end

  def subscription_attributes
    base_subscription_attributes.merge(coupon_attributes)
  end

  def base_subscription_attributes
    {
      plan: @checkout.subscribeable_sku,
      quantity: @checkout.quantity
    }
  end

  def coupon_attributes
    if @checkout.stripe_coupon_id.present?
      { coupon: @checkout.stripe_coupon_id }
    else
      {}
    end
  end

  def stripe_customer
    @stripe_customer ||=
      Stripe::Customer.retrieve(@checkout.stripe_customer_id)
  end
end
