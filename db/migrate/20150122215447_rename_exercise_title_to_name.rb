class RenameExerciseTitleToName < ActiveRecord::Migration[4.2]
  def change
    rename_column :exercises, :title, :name
  end
end
