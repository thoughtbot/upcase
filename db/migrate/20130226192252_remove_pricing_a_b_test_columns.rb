class RemovePricingABTestColumns < ActiveRecord::Migration
  def change
    remove_column :products, :alternate_company_price
    remove_column :products, :alternate_individual_price

    remove_column :workshops, :alternate_company_price
    remove_column :workshops, :alternate_individual_price
  end
end
