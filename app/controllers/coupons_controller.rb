class CouponsController < ApplicationController
  def show
    if coupon.valid?
      session[:coupon] = coupon.code
      flash[:notice] = t("coupons.flashes.success", code: coupon.code)
    else
      flash[:error] = t("coupons.flashes.invalid")
    end

    redirect_to root_path
  end

  private

  def coupon
    @coupon ||= Coupon.new(params[:id])
  end
end
