class SwitchFromGithubTeamsToCollaborators < ActiveRecord::Migration[4.2]
  MAPPINGS = {
    1036719 => "thoughtbot/upcase",
    1036722 => "thoughtbot/upcase-exercises",
    1036723 => "thoughtbot/payload",
    1241024 => "thoughtbot/intermediate-rails",
    1241049 => "thoughtbot/hands-on-backbone-js-on-rails",
    1241069 => "thoughtbot/analytics-for-developers",
    1241250 => "thoughtbot/intro-rails-ruby",
    1241260 => "thoughtbot/intro-rails-app",
    1241271 => "thoughtbot/test-driven-rails-app1",
    1241320 => "thoughtbot/test-driven-rails-app2",
    1241364 => "thoughtbot/getting-started-with-ios-workshop"
  }

  def up
    add_column :products, :github_repository, :string
    MAPPINGS.each do |team, repo|
      connection.update(<<-SQL)
        UPDATE products
        SET github_repository = '#{repo}'
        WHERE github_team = #{team}
      SQL
    end
    remove_column :products, :github_team
  end

  def down
    add_column :products, :github_team, :integer
    MAPPINGS.each do |team, repo|
      connection.update(<<-SQL)
        UPDATE products
        SET github_team = #{team}
        WHERE github_repository = '#{repo}'
      SQL
    end
    remove_column :products, :github_repository
  end
end
