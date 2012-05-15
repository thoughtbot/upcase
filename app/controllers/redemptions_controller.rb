class RedemptionsController < ApplicationController
  def new
    @coupon = Coupon.find_by_code_and_active(params[:coupon][:code], true)
    if params[:section_id]
      @buying = Section.find(params[:section_id]).registrations.build(coupon: @coupon)
    elsif params[:product_id]
      @buying = Product.find(params[:product_id]).purchases.build(variant: params[:variant], coupon: @coupon)
    end
  end
end
