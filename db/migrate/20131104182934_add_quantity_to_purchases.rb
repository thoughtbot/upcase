class AddQuantityToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :quantity, :integer, null: false, default: 1
  end
end
