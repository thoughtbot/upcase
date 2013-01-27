module VideosHelper
  def video_availability_class(video, purchaseable)
    if purchaseable.video_available?(video)
      'available'
    else
      'unavailable'
    end
  end
end
