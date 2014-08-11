class ProductsController < ApplicationController
  def index
    @catalog = Catalog.new
  end

  def show
    @offering = Offering.new(product, current_user)

    if @offering.user_has_license?
      render polymorphic_licenseable_template
    end
  end

  private

  def product
    Product.friendly.find(params[:id])
  end
end
