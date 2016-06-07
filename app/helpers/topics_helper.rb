module TopicsHelper
  def topic_classes(topics)
    topics.map { |topic| topic.slug.parameterize }.join(" ")
  end

  def resource_classes(resource)
    classes = ["resource"]
    classes << resource_type(resource)
    classes.join(" ")
  end

  private

  def resource_type(resource)
    resource["type"]
  end
end
