class RemoveTeamPlanIdFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :team_plan_id
  end
end
