class VideosController < ApplicationController
  def index
    load_context
    redirect_if_unpaid
  end

  def show
    load_context
    redirect_if_unpaid and return
    @video = @purchase.purchaseable.videos.find(params[:id])
  end

  private

  def load_context
    @purchase = Purchase.find_by_lookup!(params[:purchase_id])
  end

  def redirect_if_unpaid
    if !@purchase.paid?
      redirect_to root_path
    end
  end
end
