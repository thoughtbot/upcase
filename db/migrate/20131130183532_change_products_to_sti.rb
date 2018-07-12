class ChangeProductsToSti < ActiveRecord::Migration[4.2]
  def change
    rename_column :products, :product_type, :type

    update "UPDATE products SET type = 'Screencast' WHERE type='video'"
    update "UPDATE products SET type = 'Book' WHERE type='book'"

    change_column_null :products, :type, false
  end
end
