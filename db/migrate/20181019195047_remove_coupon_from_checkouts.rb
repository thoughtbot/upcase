class RemoveCouponFromCheckouts < ActiveRecord::Migration[5.2]
  def change
    remove_column :checkouts, :stripe_coupon_id, :string, limit: 255
  end
end
