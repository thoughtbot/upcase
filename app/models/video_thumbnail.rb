class VideoThumbnail
  attr_reader :wistia_id

  def initialize(clip)
    @wistia_id = clip.wistia_id
  end

  def to_partial_path
    'video_thumbnails/video_thumbnail'
  end
end
