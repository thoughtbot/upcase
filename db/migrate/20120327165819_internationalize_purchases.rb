class InternationalizePurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :country, :string
  end

  def self.down
    remove_column :purchases, :country
  end
end
