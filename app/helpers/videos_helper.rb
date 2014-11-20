module VideosHelper
  def video_description(video, length: 250)
    truncate(strip_tags(video.notes_html), escape: false, length: length)
  end
end
