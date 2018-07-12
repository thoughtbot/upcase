class AddCouponToRegistration < ActiveRecord::Migration[4.2]
  def self.up
    add_column :registrations, :coupon_id, :integer
  end

  def self.down
    remove_column :registrations, :coupon_id
  end
end
