class StripeRedemptionsController < ApplicationController
  def new
    @purchase = purchaseable.purchases.build(variant: params[:variant])
    @subscription_coupon = SubscriptionCoupon.new(params[:coupon][:code])
  end

  private

  def purchaseable
    Product.find(params[:product_id])
  end
end
