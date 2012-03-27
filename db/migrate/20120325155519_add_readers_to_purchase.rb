class AddReadersToPurchase < ActiveRecord::Migration
  def self.up
    add_column :purchases, :readers, :text
  end

  def self.down
    remove_column :purchases, :readers
  end
end
