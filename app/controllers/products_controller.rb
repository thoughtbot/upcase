class ProductsController < ApplicationController
  def index
    @in_person_workshops = Course.only_public.by_position.in_person
    online_courses = Course.only_public.by_position.online
    # This `workshops = `line can be removed on 2013-01-16, when
    # Product.workshops will be empty and all online workshops will be in
    # Course.
    workshops = Product.workshops.active.ordered
    @online_workshops = online_courses + workshops
    @books = Product.books.active.ordered
    @videos = Product.videos.active.ordered
  end

  def show
    @product = Product.find(params[:id])

    km.record("Viewed Product", { "Product Name" => @product.name })
  end
end
