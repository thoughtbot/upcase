class AddActiveToCoupons < ActiveRecord::Migration[4.2]
  def self.up
    add_column :coupons, :active, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :coupons, :active
  end
end
