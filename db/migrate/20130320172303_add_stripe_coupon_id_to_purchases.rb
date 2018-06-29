class AddStripeCouponIdToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :stripe_coupon_id, :string
  end
end
