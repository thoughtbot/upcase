class MultipleVideosOnProducts < ActiveRecord::Migration
  def up
    create_table :videos do |t|
      t.integer :product_id
      t.string  :wistia_id
      t.string  :title

      t.timestamps
    end

    execute "insert into videos (product_id, wistia_id, created_at, updated_at) SELECT id, wistia_id, now(), now() from products where wistia_id is not null and wistia_id != ''"

    remove_column :products, :wistia_id
  end

  def down
    add_column :products, :wistia_id, :string

    update "update products set wistia_id=videos.wistia_id from videos where products.id=videos.product_id"

    drop_table :videos
  end
end
