class CleanExerciseClassifications < ActiveRecord::Migration
  def up
    delete <<-SQL
      DELETE FROM classifications WHERE classifiable_type = 'Exercise';
    SQL
  end

  def down
  end
end
