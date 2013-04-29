class AddGithubTeamToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :github_team, :integer
  end
end
