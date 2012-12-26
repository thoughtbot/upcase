class ProductsController < ApplicationController
  def index
    @courses = Course.only_public.by_position
    @books = Product.books.active.ordered
    @videos = Product.videos.active.ordered
    @workshops = Product.workshops.active.ordered
  end

  def show
    @product = Product.find(params[:id])

    km.record("Viewed Product", { "Product Name" => @product.name })
  end
end
