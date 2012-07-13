class VideosController < ApplicationController
  def show
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.find_by_lookup!(params[:purchase_id])
    @video = @product.videos.find(params[:id])
  end
end
