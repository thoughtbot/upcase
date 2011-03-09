class RedemptionsController < ApplicationController
  def new
    @section = Section.find(params[:section_id])
    @coupon = Coupon.find_by_code_and_active(params[:coupon][:code], true)
  end
end
