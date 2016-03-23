module TopicsHelper
  def topic_class(topic)
    topic.slug.parameterize
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
