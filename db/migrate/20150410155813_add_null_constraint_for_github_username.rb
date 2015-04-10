class AddNullConstraintForGithubUsername < ActiveRecord::Migration
  def change
    change_column :users, :github_username, :string, null: false
  end
end
