class AddCouponToPurchase < ActiveRecord::Migration
  def self.up
    add_column :purchases, :coupon_id, :integer
  end

  def self.down
    remove_column :purchases, :coupon_id
  end
end
