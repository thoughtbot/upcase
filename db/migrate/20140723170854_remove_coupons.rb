class RemoveCoupons < ActiveRecord::Migration[4.2]
  def change
    drop_table :coupons
  end
end
