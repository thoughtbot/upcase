class RenamePriceToIndividualPrice < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :products, :price, :individual_price
  end

  def self.down
    rename_column :products, :individual_price, :price
  end
end
