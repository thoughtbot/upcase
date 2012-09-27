class AddPromoLocationToProductsAndCourses < ActiveRecord::Migration
  def change
    add_column :courses, :promo_location, :string
    add_column :products, :promo_location, :string
  end
end
