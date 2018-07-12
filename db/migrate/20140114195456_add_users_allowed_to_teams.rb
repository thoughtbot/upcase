class AddUsersAllowedToTeams < ActiveRecord::Migration[4.2]
  def up
    add_column :teams, :max_users, :integer

    change_column_null :teams, :max_users, false, 0
  end

  def down
    remove_column :teams, :max_users
  end
end
