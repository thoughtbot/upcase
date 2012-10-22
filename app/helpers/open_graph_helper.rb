module OpenGraphHelper
  def open_graph_tags
    tag('meta', property: 'og:image', content: image_url('learn/learn-ralph.png'))
  end

  private

  def image_url(filename)
    URI.join(root_url, image_path(filename))
  end
end
