module OpenGraphHelper
  def open_graph_tags
    raw [
      tag("meta", property: "og:image", content: image_url("thoughtbot_horizontal_default_red_on_light.png")),
      tag("meta", property: "og:url", content: url_for(only_path: false)),
      tag("meta", property: "og:title", content: page_title)
    ].join("\n")
  end

  private

  def image_url(filename)
    URI.join(root_url, image_path(filename))
  end
end
