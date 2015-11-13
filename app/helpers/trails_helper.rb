module TrailsHelper
  def trail_breadcrumbs(trail, separator = ">")
    [trail.topic, trail].map { |obj| link_to(obj, obj) }.
      unshift(link_to("Trails", practice_path)).
      join(" #{separator} ").html_safe
  end

  def completeable_link(completeable, &block)
    if completeable.is_a?(Exercise)
      link_to completeable.url, title: completeable.name, &block
    else
      link_to completeable, title: completeable.name, &block
    end
  end
end
