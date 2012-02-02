class AddCommentsToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :comments, :text
  end

  def self.down
    remove_column :registrations, :comments
  end
end
