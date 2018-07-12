class DropPublicFromExercises < ActiveRecord::Migration[4.2]
  def change
    remove_column :exercises, :public, :boolean, default: false, null: false
  end
end
