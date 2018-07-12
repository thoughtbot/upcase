class MoveTeamPlansIntoPlans < ActiveRecord::Migration[4.2]
  def up
    say_with_time "Moving team_plans into plans" do
      # Need to reset the id_seq, because:
      #   SELECT MAX(id) FROM individual_plans => 20
      #   SELECT nextval('individual_plans_id_seq') => 10
      execute(<<-SQL)
        SELECT setval('individual_plans_id_seq',
          (SELECT MAX(id) FROM individual_plans))
      SQL

      # Move team_plans data into individual_plans
      insert(<<-SQL)
        INSERT INTO individual_plans (sku, name, individual_price, terms, includes_mentor,
          includes_video_tutorials, featured, description, includes_exercises,
          includes_source_code, includes_forum, includes_books,
          includes_screencasts, includes_office_hours, includes_shows,
          created_at, updated_at,
          includes_team, short_description)

        SELECT sku, name, individual_price, terms, includes_mentor,
          includes_video_tutorials, featured, description, includes_exercises,
          includes_source_code, includes_forum, includes_books,
          includes_screencasts, includes_office_hours, includes_shows,
          created_at, updated_at,
          TRUE, name FROM team_plans
      SQL
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
