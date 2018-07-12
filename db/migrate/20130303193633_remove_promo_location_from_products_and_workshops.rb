class RemovePromoLocationFromProductsAndWorkshops < ActiveRecord::Migration[4.2]
  def up
    remove_column :products, :promo_location
    remove_column :workshops, :promo_location
  end

  def down
    add_column :workshops, :promo_location, :string
    add_column :products, :promo_location, :string
  end
end
