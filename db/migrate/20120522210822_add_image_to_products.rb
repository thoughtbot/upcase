class AddImageToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :product_image_file_name, :string
    add_column :products, :product_image_file_size, :string
    add_column :products, :product_image_content_type, :string
    add_column :products, :product_image_updated_at, :string
  end
end

