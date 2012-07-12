module TopicsHelper
  def format_content(content)
    strip_tags(content).truncate(300)
  end

  def topic_classes(topics)
    topics.pluck(:slug).join(" ")
  end
end
