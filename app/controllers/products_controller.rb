class ProductsController < ApplicationController
  def index
    @catalog = Catalog.new
  end

  def show
    @product = Product.find(params[:id])
    @offering = @product

    if @license = current_user_license_of(@offering)
      render polymorphic_licenseable_template
    end
  end
end
