module VideosHelper
  def video_description(video, length: 250)
    truncate(strip_tags(video.notes_html), length: length)
  end
end
