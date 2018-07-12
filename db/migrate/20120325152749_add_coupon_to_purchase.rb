class AddCouponToPurchase < ActiveRecord::Migration[4.2]
  def self.up
    add_column :purchases, :coupon_id, :integer
  end

  def self.down
    remove_column :purchases, :coupon_id
  end
end
