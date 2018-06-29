class RenamePlansIndividualPriceToPrice < ActiveRecord::Migration[4.2]
  def change
    rename_column :plans, :individual_price, :price
    remove_column :products, :individual_price, :integer, default: 0
    remove_column :products, :company_price, :integer, default: 0
  end
end
