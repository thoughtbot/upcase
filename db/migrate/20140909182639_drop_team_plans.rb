class DropTeamPlans < ActiveRecord::Migration
  def up
    drop_table :team_plans
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
