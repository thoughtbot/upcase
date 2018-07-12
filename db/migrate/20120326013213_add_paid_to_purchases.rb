class AddPaidToPurchases < ActiveRecord::Migration[4.2]
  def self.up
    add_column :purchases, :paid, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :purchases, :paid
  end
end
