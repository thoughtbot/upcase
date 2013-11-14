class PurchasePriceCalculator < SimpleDelegator
  def calculate
    if variant.blank?
      0
    else
      calculate_price
    end
  end

  private

  def calculate_price
    if has_coupon?
      price_after_coupon_is_applied
    else
      full_price
    end
  end

  def has_coupon?
    coupon.present? || stripe_coupon_id.present?
  end

  def price_after_coupon_is_applied
    normal_or_subscription_coupon.apply(full_price)
  end

  def normal_or_subscription_coupon
    coupon || stripe_coupon
  end

  def stripe_coupon
    SubscriptionCoupon.new(stripe_coupon_id)
  end

  def full_price
    purchaseable.send(:"#{variant}_price") * quantity
  end
end
