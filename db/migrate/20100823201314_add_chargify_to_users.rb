class AddChargifyToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :customer_id, :string, :default => ''
    add_column :users, :first_name, :string, :default => ''
    add_column :users, :last_name, :string, :default => ''
    add_column :users, :organization, :string, :default => ''
    add_column :users, :reference, :string, :default => ''
  end

  def self.down
    remove_column :users, :reference
    remove_column :users, :organization
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :customer_id
  end
end
