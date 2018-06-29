class AddGithubTeamToWorkshops < ActiveRecord::Migration[4.2]
  def change
    add_column :workshops, :github_team, :integer
  end
end
