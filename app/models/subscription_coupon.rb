class SubscriptionCoupon
  delegate :duration, :duration_in_months, to: :stripe_coupon

  def initialize(coupon_code)
    @stripe_coupon_id = coupon_code
  end

  def code
    @stripe_coupon_id
  end

  def apply(full_price)
    monthly_amount(full_price)
  end

  def stripe_coupon
    @stripe_coupon ||= Stripe::Coupon.retrieve(@stripe_coupon_id)
  rescue Stripe::InvalidRequestError => exception
    @stripe_coupon = nil
  end

  def valid?
    stripe_coupon.present?
  end

  private

  def monthly_amount(full_price)
    if stripe_coupon.amount_off.present?
      full_price - cents_to_dollars(stripe_coupon.amount_off.to_i)
    end
  end

  def cents_to_dollars(amount)
    amount / 100
  end
end
