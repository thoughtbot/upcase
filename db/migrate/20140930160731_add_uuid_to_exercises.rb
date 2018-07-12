class AddUuidToExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :uuid, :string
  end
end
