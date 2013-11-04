class RedemptionsController < ApplicationController
  def new
    @coupon = Coupon.find_by_code_and_active(params[:coupon][:code], true)
    @buying = purchaseable.purchases.build(purchase_params)
    @buying.coupon = @coupon
  end

  private

  def purchaseable
    if params[:section_id]
      Section.find(params[:section_id])
    elsif params[:product_id]
      Product.find(params[:product_id])
    end
  end

  def purchase_params
    params.require(:purchase).permit(:variant, :quantity, :coupon)
  end
end
