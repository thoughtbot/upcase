class DropTeamPlans < ActiveRecord::Migration[4.2]
  def up
    drop_table :team_plans
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
