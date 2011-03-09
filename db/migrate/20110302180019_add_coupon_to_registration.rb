class AddCouponToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :coupon_id, :integer
  end

  def self.down
    remove_column :registrations, :coupon_id
  end
end
