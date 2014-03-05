class VideosController < ApplicationController
  def show
    @video_page = VideoPage.new(purchase: purchase, video: video)
    unless purchase.paid?
      redirect_to video.watchable
    end
  end

  private

  def purchase
    Purchase.find_by_lookup!(purchase_id)
  end

  def purchaseable
    purchase.purchaseable
  end

  def video
    purchaseable.videos.find(video_id)
  end

  def purchase_id
    params[:purchase_id]
  end

  def video_id
    params[:id]
  end
end
