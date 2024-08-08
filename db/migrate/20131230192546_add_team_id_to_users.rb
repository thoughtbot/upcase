class AddTeamIdToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :team_id, :integer

    say_with_time "Setting user team IDs" do
      connection.update(<<-SQL)
        WITH team_subscriptions AS (
          SELECT
            user_id,
            MIN(team_id) AS team_id
          FROM subscriptions
          GROUP BY user_id
        )
        UPDATE users
        SET team_id = team_subscriptions.team_id
        FROM team_subscriptions
        WHERE team_subscriptions.user_id = users.id
      SQL
    end

    add_index :users, :team_id
  end

  def down
    remove_column :users, :team_id
  end
end
