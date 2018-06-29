class AddPaidToRegistrations < ActiveRecord::Migration[4.2]
  def self.up
    add_column :registrations, :paid, :boolean, :null => false, :default => false
    add_index :registrations, :paid
    update "update registrations set paid=true"
  end

  def self.down
    remove_column :registrations, :paid
  end
end
