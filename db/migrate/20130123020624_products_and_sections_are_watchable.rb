class ProductsAndSectionsAreWatchable < ActiveRecord::Migration
  def up
    rename_column :videos, :purchaseable_type, :watchable_type
    rename_column :videos, :purchaseable_id, :watchable_id
    add_index :videos, [:watchable_type, :watchable_id]
  end

  def down
    rename_column :videos, :watchable_id, :purchaseable_id
    rename_column :videos, :watchable_type, :purchaseable_type
  end
end
