class AddUniqueIndexToGithubUsername < ActiveRecord::Migration[4.2]
  def change
    update "UPDATE users SET github_username = NULL WHERE github_username = '';"
    add_index :users, :github_username, unique: true
  end
end
