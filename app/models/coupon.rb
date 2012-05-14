class Coupon < ActiveRecord::Base
  DISCOUNT_TYPES = ["percentage", "dollars"]

  validates_presence_of :code, :amount, :discount_type
  validates_inclusion_of :discount_type, in: DISCOUNT_TYPES

  def apply(full_price)
    if discount_type == "percentage"
      full_price - (full_price * (amount * 0.01))
    else
      full_price - amount
    end
  end
end
