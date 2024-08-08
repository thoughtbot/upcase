class RemoveTeamIdFromSubscriptions < ActiveRecord::Migration[4.2]
  def up
    say_with_time "Deleting subscriptions for team members" do
      connection.delete(<<-SQL)
        DELETE FROM subscriptions
        WHERE team_id IS NOT NULL
          AND id NOT IN (SELECT subscription_id FROM teams)
      SQL
    end

    remove_column :subscriptions, :team_id
  end

  def down
    add_column :subscriptions, :team_id, :integer
    add_index :subscriptions, :team_id

    say_with_time "Create subscriptions for team members" do
      connection.insert(<<-SQL)
        INSERT INTO subscriptions
          (user_id, created_at, updated_at, plan_id, team_id, plan_type)
        SELECT
          users.id AS user_id,
          teams.created_at,
          teams.updated_at,
          teams.team_plan_id AS plan_id,
          teams.id AS team_id,
          'TeamPlan' As plan_type
        FROM teams
        INNER JOIN users ON users.team_id = teams.id
        LEFT JOIN subscriptions ON subscriptions.user_id = users.id
        WHERE subscriptions.id IS NULL
      SQL
    end

    say_with_time "Setting subscription teams" do
      connection.update(<<-SQL)
        UPDATE subscriptions
        SET team_id = teams.id
        FROM teams
        WHERE teams.subscription_id = subscriptions.id
      SQL
    end
  end
end
