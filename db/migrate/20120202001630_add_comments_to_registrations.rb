class AddCommentsToRegistrations < ActiveRecord::Migration[4.2]
  def self.up
    add_column :registrations, :comments, :text
  end

  def self.down
    remove_column :registrations, :comments
  end
end
