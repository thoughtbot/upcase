class RenameVideoTitleToName < ActiveRecord::Migration[4.2]
  def change
    rename_column :videos, :title, :name
  end
end
