class AddAdminToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :admin, :boolean, :default => false, :null => false
    add_index :users, :admin
  end

  def self.down
    remove_column :users, :admin
  end
end
