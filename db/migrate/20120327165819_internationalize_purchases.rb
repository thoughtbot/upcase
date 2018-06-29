class InternationalizePurchases < ActiveRecord::Migration[4.2]
  def self.up
    add_column :purchases, :country, :string
  end

  def self.down
    remove_column :purchases, :country
  end
end
