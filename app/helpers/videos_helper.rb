module VideosHelper
  def video_description(video, length: 250)
    notes_html = format_markdown(video.notes)
    truncate(strip_tags(notes_html), escape: false, length: length).chomp
  end

  def topic_slugs(object)
    if topic = object.topics.first
      topic.slug.parameterize
    end
  end
end
