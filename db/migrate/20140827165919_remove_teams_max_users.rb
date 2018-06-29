class RemoveTeamsMaxUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :teams, :max_users
  end
end
