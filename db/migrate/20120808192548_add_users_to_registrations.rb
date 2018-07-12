class AddUsersToRegistrations < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :user_id, :integer
  end
end
