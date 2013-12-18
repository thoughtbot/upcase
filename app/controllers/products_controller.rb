class ProductsController < ApplicationController
  def index
    @catalog = Catalog.new
    render layout: 'header-only'
  end

  def show
    @product = Product.find(params[:id])
    @offering = @product

    if signed_in? && @product.purchase_for(current_user)
      redirect_to @product.purchase_for(current_user)
    end
  end
end
