class IndexExercisesUuid < ActiveRecord::Migration[4.2]
  def change
    add_index :exercises, :uuid, unique: true
  end
end
