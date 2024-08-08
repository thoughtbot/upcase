class AddSubscriptionIdToTeams < ActiveRecord::Migration[4.2]
  def up
    add_column :teams, :subscription_id, :integer

    say_with_time "Setting team subscriptions" do
      connection.update(<<-SQL)
        WITH teams_with_first_subscription AS (
          SELECT
            team_id AS team_id,
            MIN(id) AS subscription_id
          FROM subscriptions
          WHERE team_id IS NOT NULL
          GROUP BY team_id
        )
        UPDATE teams
        SET subscription_id = teams_with_first_subscription.subscription_id
        FROM teams_with_first_subscription
        WHERE teams.id = teams_with_first_subscription.team_id
      SQL
    end

    change_column_null :teams, :subscription_id, false
  end

  def down
    remove_column :teams, :subscription_id
  end
end
