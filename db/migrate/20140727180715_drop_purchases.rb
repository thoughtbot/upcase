class DropPurchases < ActiveRecord::Migration[4.2]
  def change
    drop_table :purchases
  end
end
