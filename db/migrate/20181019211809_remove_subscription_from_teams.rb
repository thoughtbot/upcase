class RemoveSubscriptionFromTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :owner_id, :integer
    add_index :teams, :owner_id

    update <<-SQL.squish
      UPDATE teams
      SET owner_id = subscriptions.user_id
      FROM subscriptions
      WHERE teams.subscription_id = subscriptions.id
    SQL

    remove_column :teams, :subscription_id, :integer, null: false
  end
end
