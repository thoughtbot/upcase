class AddPromotedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :promoted, :boolean, default: false, null: false
  end
end
