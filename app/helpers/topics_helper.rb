module TopicsHelper
  def format_content(content, options = {} )
    length = options[:length] || 140
    omission = options[:omission] || '&#8230;'
    strip_tags(content).truncate(length, separator:' ', omission: omission)
  end

  def topic_classes(topics)
    topics.pluck(:slug).map(&:parameterize).join(' ')
  end
end
