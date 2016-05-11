module VideosHelper
  def topic_slugs(object)
    if topic = object.topics.first
      topic.slug.parameterize
    end
  end

  def upcase_video_url(video)
    video_url(video).
      gsub("thoughtbot.com", "upcase.com").
      gsub("/upcase/", "/")
  end
end
