class ExercisesUuidNotNull < ActiveRecord::Migration
  def change
    change_column_null :exercises, :uuid, false
  end
end
