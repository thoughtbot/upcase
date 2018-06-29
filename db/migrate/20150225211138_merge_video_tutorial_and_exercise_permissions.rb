class MergeVideoTutorialAndExercisePermissions < ActiveRecord::Migration[4.2]
  def up
    add_column :plans, :includes_trails, :boolean, default: false, null: false
    connection.update(<<-SQL)
      UPDATE plans SET includes_trails = includes_video_tutorials
    SQL
    remove_column :plans, :includes_video_tutorials
    remove_column :plans, :includes_exercises
  end

  def down
    add_column :plans, :includes_exercises, :boolean, default: true, null: false
    add_column :plans, :includes_video_tutorials, :boolean, default: true
    connection.update(<<-SQL)
      UPDATE plans SET includes_video_tutorials = includes_trails,
                       includes_exercises = includes_trails
    SQL
    remove_column :plans, :includes_trails
  end
end
