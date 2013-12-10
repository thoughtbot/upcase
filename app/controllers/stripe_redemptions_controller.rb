class StripeRedemptionsController < ApplicationController
  def new
    @purchase = requested_purchaseable.purchases.build(purchase_params)
    @subscription_coupon = SubscriptionCoupon.new(params[:coupon][:code])
  end

  private

  def purchase_params
    params.require(:purchase).permit(:variant, :quantity)
  end
end
