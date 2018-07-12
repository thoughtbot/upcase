class ChangeNameForGithubUsers < ActiveRecord::Migration[4.2]
  def up
    update <<-SQL
      UPDATE users SET name = users.github_username WHERE name = 'GitHub User'
    SQL
  end
end
