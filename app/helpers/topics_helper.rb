module TopicsHelper
  def topic_classes(topics)
    topics.pluck(:slug).map(&:parameterize).join(' ')
  end
end
