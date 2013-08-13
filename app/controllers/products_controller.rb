class ProductsController < ApplicationController
  before_filter :authorize, only: [:index]

  def index
    render layout: 'header-only'
  end

  def show
    @product = Product.find(params[:id])
    @offering = @product

    if signed_in? && @product.purchase_for(current_user)
      redirect_to @product.purchase_for(current_user)
    else
      km.record("Viewed Product", { "Product Name" => @product.name })
    end
  end
end
