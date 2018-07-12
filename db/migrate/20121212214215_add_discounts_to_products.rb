class AddDiscountsToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :discount_percentage, :integer, default: 0, null: false
    add_column :products, :discount_title, :string, default: "", null: false
  end
end
