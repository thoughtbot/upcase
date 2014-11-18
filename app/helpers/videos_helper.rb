module VideosHelper
  def videos_description(video)
    truncate(strip_tags(video.notes_html), length: 250)
  end
end
