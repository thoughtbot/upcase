class RemoveTeamPlanIdFromTeams < ActiveRecord::Migration[4.2]
  def change
    remove_column :teams, :team_plan_id
  end
end
