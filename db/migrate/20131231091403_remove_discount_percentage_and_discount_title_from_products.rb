class RemoveDiscountPercentageAndDiscountTitleFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :discount_percentage, :integer
    remove_column :products, :discount_title, :string
  end
end
