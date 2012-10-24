module OpenGraphHelper
  def open_graph_tags
    raw [
      tag('meta', property: 'og:image', content: image_url('ralph-gradient.png')),
      tag('meta', property: 'og:url', content: url_for(only_path: false)),
      tag('meta', property: 'og:title', content: title(@topic.try(:name))),
    ].join("\n")
  end

  private

  def image_url(filename)
    URI.join(root_url, image_path(filename))
  end
end
