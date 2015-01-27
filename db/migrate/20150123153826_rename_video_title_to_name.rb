class RenameVideoTitleToName < ActiveRecord::Migration
  def change
    rename_column :videos, :title, :name
  end
end
