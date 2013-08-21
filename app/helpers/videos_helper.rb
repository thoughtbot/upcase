module VideosHelper
  def single_video?(purchaseable)
    purchaseable.videos.size == 1
  end
end
