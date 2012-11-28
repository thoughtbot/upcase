class VideosController < ApplicationController
  def index
    load_context
    redirect_if_unpaid
  end

  def show
    load_context
    redirect_if_unpaid and return
    @video = @product.videos.find(params[:id])
  end

  private

  def load_context
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.find_by_lookup!(params[:purchase_id])
  end

  def redirect_if_unpaid
    if !@purchase.paid?
      redirect_to product_path(@product)
    end
  end
end
