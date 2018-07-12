class AddPromoLocationToProductsAndCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :promo_location, :string
    add_column :products, :promo_location, :string
  end
end
