class ProductsController < ApplicationController
  def index
    @catalog = Catalog.new
  end
end
