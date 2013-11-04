class StripeRedemptionsController < ApplicationController
  def new
    @purchase = purchaseable.purchases.build(purchase_params)
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

  def purchase_params
    params.require(:purchase).permit(:variant, :quantity)
  end
end
