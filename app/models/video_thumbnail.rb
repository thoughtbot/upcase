class VideoThumbnail
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def to_partial_path
    'video_thumbnails/video_thumbnail'
  end
end
