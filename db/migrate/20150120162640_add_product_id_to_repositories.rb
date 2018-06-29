class AddProductIdToRepositories < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :product_id, :integer
    add_index :products, :product_id
  end
end
