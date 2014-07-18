class RedemptionsController < ApplicationController
  def new
    @checkout = requested_subscribeable.checkouts.build(checkout_params)
    @coupon = Coupon.new(params[:coupon][:code])
  end

  private

  def checkout_params
    params.require(:checkout).permit(:quantity)
  end
end
