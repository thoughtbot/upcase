class AddStripeCouponIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :stripe_coupon_id, :string
  end
end
