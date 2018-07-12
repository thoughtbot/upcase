class AddReadersToPurchase < ActiveRecord::Migration[4.2]
  def self.up
    add_column :purchases, :readers, :text
  end

  def self.down
    remove_column :purchases, :readers
  end
end
