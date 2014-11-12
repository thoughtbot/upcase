class RedemptionsController < ApplicationController
  def new
    @checkout = plan.checkouts.build(checkout_params)
    @coupon = Coupon.new(params[:coupon][:code])
  end

  private

  def plan
    Plan.where(sku: params[:plan]).first
  end

  def checkout_params
    params.require(:checkout).permit(:quantity)
  end
end
