class ChangeMentoringDefaultToFalse < ActiveRecord::Migration[4.2]
  def up
    change_column_default :individual_plans, :includes_mentor, false
    change_column_default :team_plans, :includes_mentor, false
  end

  def down
    change_column_default :team_plans, :includes_mentor, true
    change_column_default :individual_plans, :includes_mentor, true
  end
end
