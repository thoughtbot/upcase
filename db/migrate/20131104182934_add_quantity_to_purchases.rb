class AddQuantityToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :quantity, :integer, null: false, default: 1
  end
end
