class Coupon < ActiveRecord::Base
  DISCOUNT_TYPES = ["percentage", "dollars"]

  validates_presence_of :code, :amount, :discount_type
  validates_inclusion_of :discount_type, in: DISCOUNT_TYPES

  def apply(full_price)
    if active
      discounted_price(full_price)
    else
      full_price
    end
  end

  def applied
    if one_time_use_only
      update_attributes(active: false)
    end
  end

  private

  def discounted_price(full_price)
    if discount_type == "percentage"
      full_price - (full_price * (amount * 0.01))
    else
      full_price - amount
    end
  end
end
