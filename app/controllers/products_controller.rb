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

  private

  def ab_test_chrome_screencast
    if @product.name == "Hidden Secrets of the Chrome Developer Tools"
      if ab_test('new_chrome_cast_description', 'original', 'alternative') == 'alternative'
        render 'alternative'
      end
    end
  end
end
