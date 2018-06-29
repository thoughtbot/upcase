class RemoveCheckoutsQuantity < ActiveRecord::Migration[4.2]
  def up
    remove_column :checkouts, :quantity
    add_column :plans, :minimum_quantity, :integer, default: 1, null: false
    update "UPDATE plans SET minimum_quantity = 3 WHERE includes_team = true"
  end

  def down
    add_column :checkouts, :quantity, :integer, default: 1, null: false
    remove_column :plans, :minimum_quantity
  end
end
