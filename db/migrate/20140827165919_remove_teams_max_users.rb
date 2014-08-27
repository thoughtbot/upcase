class RemoveTeamsMaxUsers < ActiveRecord::Migration
  def change
    remove_column :teams, :max_users
  end
end
