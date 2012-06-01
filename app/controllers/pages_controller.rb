class PagesController < ApplicationController
  def home
    @audiences = Audience.by_position
    @books = Product.active.where("product_type LIKE '%book%'")
    @screencasts = Product.active.where("product_type LIKE '%screencast%'")
  end
end
