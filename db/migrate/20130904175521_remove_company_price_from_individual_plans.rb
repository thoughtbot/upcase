class RemoveCompanyPriceFromIndividualPlans < ActiveRecord::Migration
  def up
    remove_column :individual_plans, :company_price
  end

  def down
    add_column :individual_plans, :company_price, :integer, default: 0
    change_column_null :individual_plans, :company_price, false
  end
end
