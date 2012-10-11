class ProductsController < ApplicationController
  def index
    @courses = Course.only_public.by_position
    @books = Product.books.ordered
    @videos = Product.videos.ordered
  end

  def show
    @product = Product.find(params[:id])

    ab_test_chrome_screencast
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
