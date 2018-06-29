class AssociateSubscriptionsWithTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :team_id, :integer
  end
end
