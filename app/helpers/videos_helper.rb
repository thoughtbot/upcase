module VideosHelper
  def video_description(video, length: 250)
    truncate(strip_tags(video.notes_html), escape: false, length: length)
  end

  def topic_slugs(object)
    if topic = object.topics.first
      topic.slug.parameterize
    end
  end
end
