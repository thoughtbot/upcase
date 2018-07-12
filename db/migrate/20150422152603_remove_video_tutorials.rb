class RemoveVideoTutorials < ActiveRecord::Migration[4.2]
  def up
    drop_table :downloads

    remove_column :products, :product_id
  end

  def down
    add_column :products, :product_id, :integer
    add_index :products, :product_id

    create_table :downloads do |table|
      table.string :description, limit: 255
      table.integer :purchaseable_id
      table.string :purchaseable_type, limit: 255
      table.string :download_file_name, limit: 255
      table.string :download_file_size, limit: 255
      table.string :download_content_type, limit: 255
      table.string :download_updated_at, limit: 255
      table.datetime :created_at, null: false
      table.datetime :updated_at, null: false
    end
  end
end
