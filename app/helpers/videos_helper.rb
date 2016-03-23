module VideosHelper
  def topic_slugs(object)
    if topic = object.topics.first
      topic.slug.parameterize
    end
  end
end
