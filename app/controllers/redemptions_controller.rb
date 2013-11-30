class RedemptionsController < ApplicationController
  def new
    @coupon = Coupon.find_by_code_and_active(params[:coupon][:code], true)
    @buying = requested_purchaseable.purchases.build(purchase_params)
    @buying.coupon = @coupon
  end

  private

  def purchase_params
    params.require(:purchase).permit(:variant, :quantity, :coupon)
  end
end
