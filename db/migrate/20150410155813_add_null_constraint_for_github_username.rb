class AddNullConstraintForGithubUsername < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :github_username, :string, null: false
  end
end
