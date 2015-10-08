module TrailsHelper
  def trail_breadcrumbs(trail, separator = ">")
    [trail.topic, trail].map { |obj| link_to(obj, obj) }.
      unshift(link_to("Trails", practice_path)).
      join(" #{separator} ").html_safe
  end
end
