class VideosController < ApplicationController
  def show
    @purchase = Purchase.find_by_lookup!(params[:purchase_id])
    @purchaseable = @purchase.purchaseable
    @video = @purchaseable.videos.find(params[:id])
    unless @purchase.paid?
      redirect_to @video.watchable
    end
  end
end
