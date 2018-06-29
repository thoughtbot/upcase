class CleanExerciseClassifications < ActiveRecord::Migration[4.2]
  def up
    delete <<-SQL
      DELETE FROM classifications WHERE classifiable_type = 'Exercise';
    SQL
  end

  def down
  end
end
