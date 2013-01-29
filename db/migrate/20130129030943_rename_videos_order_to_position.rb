class RenameVideosOrderToPosition < ActiveRecord::Migration
  def up
    rename_column :videos, :order, :position
  end

  def down
    rename_column :videos, :position, :order
  end
end
