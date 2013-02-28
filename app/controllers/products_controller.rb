class ProductsController < ApplicationController
  def index
    @in_person_workshops = Workshop.only_public.by_position.in_person
    online_workshops = Workshop.only_public.by_position.online
    # This `workshops = `line can be removed on 2013-01-16, when
    # Product.workshops will be empty and all online workshops will be in
    # Workshop.
    workshop_products = Product.workshops.active.ordered
    @online_workshops = online_workshops + workshop_products
    @books = Product.books.active.ordered
    @videos = Product.videos.active.ordered
    @articles = Article.local.top.published
  end

  def show
    @product = Product.find(params[:id])

    if signed_in? && @product.purchase_for(current_user)
      redirect_to @product.purchase_for(current_user)
    else
      km.record("Viewed Product", { "Product Name" => @product.name })
    end
  end
end
