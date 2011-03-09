class Coupon < ActiveRecord::Base
  validates_presence_of :code, :percentage
end
