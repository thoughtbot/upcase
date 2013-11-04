class StripeRedemptionsController < ApplicationController
  def new
    @purchase = purchaseable.purchases.build(variant: variant)
    @subscription_coupon = SubscriptionCoupon.new(params[:coupon][:code])
  end

  private

  def purchaseable
    if params[:individual_plan_id]
      IndividualPlan.find_by_sku!(params[:individual_plan_id])
    else
      TeamPlan.find_by_sku!(params[:team_plan_id])
    end
  end

  def variant
    if params[:variant].present?
      params[:variant]
    else
      'individual'
    end
  end
end
