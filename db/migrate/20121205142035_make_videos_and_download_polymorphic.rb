class MakeVideosAndDownloadPolymorphic < ActiveRecord::Migration
  def up
    rename_column :videos, :product_id, :purchaseable_id
    add_column :videos, :purchaseable_type, :string
    update "update videos set purchaseable_type = 'Product'"

    rename_column :downloads, :product_id, :purchaseable_id
    add_column :downloads, :purchaseable_type, :string
    update "update downloads set purchaseable_type = 'Product'"
  end

  def down
    remove_column :downloads, :purchaseable_type
    rename_column :downloads, :purchaseable_id, :product_id
    remove_column :videos, :purchaseable_type
    rename_column :videos, :purchaseable_id, :product_id
  end
end
