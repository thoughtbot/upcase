class AddIndexesToTeams < ActiveRecord::Migration[4.2]
  def change
    add_index :teams, :subscription_id
  end
end
