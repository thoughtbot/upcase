class AddDiscountsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :discount_percentage, :integer, default: 0, null: false
    add_column :products, :discount_title, :string, default: "", null: false
  end
end
