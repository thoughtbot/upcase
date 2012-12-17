class RedemptionsController < ApplicationController
  def new
    @coupon = Coupon.find_by_code_and_active(params[:coupon][:code], true)
    @buying = purchaseable.purchases.build(variant: params[:variant], coupon: @coupon)
  end

  private

  def purchaseable
    if params[:section_id]
      Section.find(params[:section_id])
    elsif params[:product_id]
      Product.find(params[:product_id])
    end
  end
end
