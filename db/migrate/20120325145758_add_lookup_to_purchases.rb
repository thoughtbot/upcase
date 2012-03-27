class AddLookupToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :lookup, :string
    add_index :purchases, :lookup
  end

  def self.down
    remove_column :purchases, :lookup
  end
end
