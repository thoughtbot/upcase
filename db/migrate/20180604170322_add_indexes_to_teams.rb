class AddIndexesToTeams < ActiveRecord::Migration
  def change
    add_index :teams, :subscription_id
  end
end
