class AddPaymentMethodToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :payment_method, :string, :default => "stripe", :null => false
  end

  def self.down
    remove_column :purchases, :payment_method
  end
end
