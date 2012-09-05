class Coupon < ActiveRecord::Base
  DISCOUNT_TYPES = ["percentage", "dollars"]

  validates_presence_of :code, :amount, :discount_type
  validates_inclusion_of :discount_type, in: DISCOUNT_TYPES

  def apply(full_price)
    full_price - discount(full_price)
  end

  def applied
    update_attributes(active: false) if one_time_use_only?
  end

  private

  def discount(full_price)
    if inactive?
      0
    elsif discount_type == "percentage"
      full_price * amount * 0.01
    else
      amount
    end
  end

  def inactive?
    !active
  end
end
