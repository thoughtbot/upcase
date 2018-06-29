class RenameReadersToGithubUsernames < ActiveRecord::Migration[4.2]
  def up
    rename_column :purchases, :readers, :github_usernames
  end

  def down
    rename_column :purchases, :github_usernames, :readers
  end
end
