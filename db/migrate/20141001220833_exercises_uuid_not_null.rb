class ExercisesUuidNotNull < ActiveRecord::Migration[4.2]
  def change
    change_column_null :exercises, :uuid, false
  end
end
