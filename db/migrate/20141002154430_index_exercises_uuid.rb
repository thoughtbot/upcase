class IndexExercisesUuid < ActiveRecord::Migration
  def change
    add_index :exercises, :uuid, unique: true
  end
end
