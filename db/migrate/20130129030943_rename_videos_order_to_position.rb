class RenameVideosOrderToPosition < ActiveRecord::Migration[4.2]
  def up
    rename_column :videos, :order, :position
  end

  def down
    rename_column :videos, :position, :order
  end
end
