module CouponsHelper
  def coupon_amount(coupon)
    if coupon.discount_type == "percentage"
      number_to_percentage coupon.amount, precision: 0
    else
      number_to_currency coupon.amount, precision: 0
    end
  end
end
