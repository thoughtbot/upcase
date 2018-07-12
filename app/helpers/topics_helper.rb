module TopicsHelper
  def topic_classes(topics)
    topics.map { |topic| topic.slug.parameterize }.join(" ")
  end
end
