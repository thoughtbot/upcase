class StripeRedemptionsController < ApplicationController
  def new
    @purchase = purchaseable.purchases.build(variant: variant)
    @subscription_coupon = SubscriptionCoupon.new(params[:coupon][:code])
  end

  private

  def purchaseable
    IndividualPlan.find_by_sku!(params[:individual_plan_id])
  end

  def variant
    if params[:variant].present?
      params[:variant]
    else
      'individual'
    end
  end
end
