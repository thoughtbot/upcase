module TopicsHelper
  def format_content(content, options = {} )
    length = options[:length] || 140
    omission = options[:omission] || '&#8230;'
    strip_tags(content).truncate(length, separator:' ', omission: omission)
  end

  def topic_classes(topics)
    topics.pluck(:slug).map(&:parameterize).join(' ')
  end

  def resource_classes(resource)
    classes = ['resource']
    if learn_resource?(resource['uri'])
      classes << 'learn-resource'
    end
    classes.join(' ')
  end

  private

  def learn_resource?(uri)
    Addressable::URI.parse(uri).host == 'learn.thoughtbot.com'
  end
end
