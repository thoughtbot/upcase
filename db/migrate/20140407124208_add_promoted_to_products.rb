class AddPromotedToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :promoted, :boolean, default: false, null: false
  end
end
