class AddAlternatePricesToProductsAndWorkshops < ActiveRecord::Migration
  def change
    %w(workshops products).each do |table|
      add_column table, :alternate_individual_price, :integer
      add_column table, :alternate_company_price, :integer
    end
  end
end
