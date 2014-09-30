class AddUuidToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :uuid, :string
  end
end
