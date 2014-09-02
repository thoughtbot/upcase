class Coupon
  delegate :duration, :duration_in_months, to: :stripe_coupon

  def initialize(coupon_code)
    @stripe_coupon_id = coupon_code
  end

  def code
    @stripe_coupon_id
  end

  def apply(full_price)
    full_price - monthly_deduction(full_price)
  end

  def stripe_coupon
    @stripe_coupon ||= Stripe::Coupon.retrieve(@stripe_coupon_id)
  rescue Stripe::APIError
    @stripe_coupon = nil
  end

  def valid?
    stripe_coupon.present?
  end

  private

  def monthly_deduction(full_price)
    if stripe_coupon.amount_off.present?
      cents_to_dollars(stripe_coupon.amount_off.to_i)
    elsif stripe_coupon.percent_off.present?
      percent_to_dollars(full_price, stripe_coupon.percent_off)
    end
  end

  def percent_to_dollars(full_price, percentage)
    full_price * percent_to_decimal(percentage)
  end

  def percent_to_decimal(percentage)
    percentage.to_f / 100
  end

  def cents_to_dollars(amount)
    amount / 100
  end
end
