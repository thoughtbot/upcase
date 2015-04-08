module StripeHelpers
  def stub_stripe_to_fail
    FakeStripe.failure = true
  end

  def create_amount_stripe_coupon(id, duration, amount_off)
    Stripe::Coupon.create(id: id, duration: duration, amount_off: amount_off)
  end

  def create_recurring_stripe_coupon(id, duration, amount_off)
    Stripe::Coupon.create(
      id: id,
      duration: 'repeating',
      duration_in_months: duration,
      amount_off: amount_off
    )
  end

  def create_percentage_off_stripe_coupon(id, duration, percent_off)
    Stripe::Coupon.create(id: id, duration: duration, percent_off: percent_off)
  end
end
