module VideosHelper
  def video_availability_class(video, purchase)
    if video.available?(purchase.starts_on)
      'available'
    else
      'unavailable'
    end
  end

  def single_video?(purchaseable)
    purchaseable.videos.size == 1
  end
end
