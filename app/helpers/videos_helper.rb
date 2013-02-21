module VideosHelper
  def video_availability_class(video, purchaseable)
    if video.available?(purchaseable.starts_on)
      'available'
    else
      'unavailable'
    end
  end
end
