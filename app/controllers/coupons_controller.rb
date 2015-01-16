class CouponsController < ApplicationController
  def show
    if coupon.valid?
      session[:coupon] = coupon.code
    else
      flash[:notice] = "The coupon code you supplied is not valid."
    end

    redirect_to root_path
  end

  private

  def coupon
    @coupon ||= Coupon.new(params[:id])
  end
end
