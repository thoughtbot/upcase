class CouponFactory
  def self.for_purchase(purchase)
    purchase.coupon || subscription_coupon(purchase) || NullCoupon.new
  end

  private

  def self.subscription_coupon(purchase)
    if purchase.stripe_coupon_id.present?
      SubscriptionCoupon.new(purchase.stripe_coupon_id)
    end
  end
end
