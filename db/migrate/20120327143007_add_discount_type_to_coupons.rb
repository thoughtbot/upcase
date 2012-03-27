class AddDiscountTypeToCoupons < ActiveRecord::Migration
  def self.up
    add_column :coupons, :discount_type, :string, :default => "percentage", :null => false
    rename_column :coupons, :percentage, :amount
  end

  def self.down
    rename_column :coupons, :amount, :percentage
    remove_column :coupons, :discount_type
  end
end
