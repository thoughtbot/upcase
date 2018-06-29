class MoveVideoTutorialsIntoProducts < ActiveRecord::Migration[4.2]
  def up
    say_with_time "Moving video_tutorials into products" do
      # Move team_plans data into individual_plans
      insert(<<-SQL)
        INSERT INTO products (sku, name, terms, description, short_description,
          length_in_days, active, github_team, promoted, slug, resources,
          tagline, type)

        SELECT sku, name, terms, description, short_description,
          length_in_days, active, github_team, promoted, slug, resources,
          short_description, 'VideoTutorial'
          FROM video_tutorials
      SQL
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
