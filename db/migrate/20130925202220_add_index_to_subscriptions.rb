class AddIndexToSubscriptions < ActiveRecord::Migration
  def change
    add_index :subscriptions, :user_id
    add_index :subscriptions, :team_id
    add_index :subscriptions, [:plan_id, :plan_type]
  end
end
