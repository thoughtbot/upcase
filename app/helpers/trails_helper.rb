module TrailsHelper
  def trail_breadcrumbs(trail, separator = ">")
    links = [
      link_to("Trails", practice_path),
      trail.topics.map { |topic| link_to(topic, topic) },
      link_to(trail, trail)
    ].flatten

    links.join(" #{separator} ").html_safe
  end

  def completeable_link(completeable, &)
    if completeable.is_a?(Exercise)
      link_to(completeable.url, title: completeable.name, &)
    else
      link_to completeable, title: completeable.name, &
    end
  end

  def trail_call_to_action(trail)
    if signed_in?
      start_trail_link(trail.first_completeable)
    else
      visit_trail_link(trail)
    end
  end

  def start_trail_link(url)
    link_to(
      t("trails.start_trail"),
      url,
      class: "start-trail cta-button small-button"
    )
  end

  def visit_trail_link(trail)
    link_to(
      t("trails.visit_trail"),
      trail,
      class: "cta-button small-button"
    )
  end

  def auth_to_access_button(video, cta_text: t("trails.start_for_free"))
    cta_classes = "cta-button light-bg"
    link_to video_auth_to_access_path(video), class: cta_classes do
      image_tag("github-black.svg", class: "logo", alt: "") + cta_text
    end
  end

  def completion_time(total_in_minutes)
    "#{hours(total_in_minutes / 60)} #{minutes(total_in_minutes % 60)}".strip
  end

  def hours(num_hours)
    return if num_hours.zero?

    pluralize(num_hours, "hour")
  end

  def minutes(num_minutes)
    return if num_minutes.zero?

    pluralize(num_minutes, "minute")
  end
end
