module TopicsHelper
  def format_content(content)
    strip_tags(content).truncate(140, separator:' ', omission:'&#8230;')
  end

  def topic_classes(topics)
    topics.pluck(:slug).join(' ')
  end
end
