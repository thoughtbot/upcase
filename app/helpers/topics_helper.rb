module TopicsHelper
  def format_content(content, options = {} )
    length = options[:length] || 140
    omission = options[:omission] || "&#8230;"
    strip_tags(content).truncate(length, separator: " ", omission: omission)
  end

  def topic_classes(topics)
    topics.map(&:slug).map(&:parameterize).join(" ")
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
