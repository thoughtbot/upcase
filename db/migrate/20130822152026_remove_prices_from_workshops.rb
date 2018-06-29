class RemovePricesFromWorkshops < ActiveRecord::Migration[4.2]
  def up
    remove_column :workshops, :individual_price
    remove_column :workshops, :company_price
  end

  def down
    add_column :workshops, :company_price, :integer
    add_column :workshops, :individual_price, :integer
  end
end
