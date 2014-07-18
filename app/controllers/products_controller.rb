class ProductsController < ApplicationController
  def index
    @catalog = Catalog.new
  end

  def show
    @product = Product.find(params[:id])
    @offering = @product

    if purchase = current_user_license_of(@product)
      redirect_to purchase
    end
  end
end
