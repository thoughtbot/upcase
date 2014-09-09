class DropTeamPlans < ActiveRecord::Migration
  def change
    drop_table :team_plans
  end
end
