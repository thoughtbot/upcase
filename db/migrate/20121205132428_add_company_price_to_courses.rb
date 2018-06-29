class AddCompanyPriceToCourses < ActiveRecord::Migration[4.2]
  def up
    rename_column :courses, :price, :individual_price
    add_column :courses, :company_price, :integer
  end

  def down
    remove_column :courses, :company_price
    rename_column :courses, :individual_price, :price
  end
end
