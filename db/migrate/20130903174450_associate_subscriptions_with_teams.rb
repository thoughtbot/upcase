class AssociateSubscriptionsWithTeams < ActiveRecord::Migration
  def change
    add_column :subscriptions, :team_id, :integer
  end
end
