class AddAdminToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false, :null => false
    add_index :users, :admin
  end

  def self.down
    remove_column :users, :admin
  end
end
