class DropPublicFromExercises < ActiveRecord::Migration
  def change
    remove_column :exercises, :public, :boolean, default: false, null: false
  end
end
