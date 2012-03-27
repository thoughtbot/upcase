class RedemptionsController < ApplicationController
  def new
    if params[:section_id]
      @buying = Section.find(params[:section_id])
    elsif params[:product_id]
      @buying = Product.find(params[:product_id]).purchases.build(:variant => params[:variant])
    end
    @coupon = Coupon.find_by_code_and_active(params[:coupon][:code], true)
  end
end
