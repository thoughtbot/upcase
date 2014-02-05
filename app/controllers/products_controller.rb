class ProductsController < ApplicationController
  def index
    @catalog = Catalog.new
    render layout: 'header-only'
  end

  def show
    @product = Product.find(params[:id])
    @offering = @product

    if purchase = current_user_purchase_of(@product)
      redirect_to purchase
    end
  end
end
