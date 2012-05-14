class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.integer :product_id
      t.string :download_file_name
      t.string :download_file_size
      t.string :download_content_type
      t.string :download_updated_at
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end
