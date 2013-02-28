class RemovePricingABTestColumns < ActiveRecord::Migration
  def up
    remove_column :products, :alternate_company_price
    remove_column :products, :alternate_individual_price

    remove_column :workshops, :alternate_company_price
    remove_column :workshops, :alternate_individual_price
  end

  def down
    add_column :products, :alternate_company_price, :integer
    add_column :products, :alternate_individual_price, :integer

    add_column :workshops, :alternate_company_price, :integer
    add_column :workshops, :alternate_individual_price, :integer
  end
end
