module TrailsHelper
  # FIXME: does this look good
  def trail_breadcrumbs(trail, separator = ">")
    topics_links = trail.topics.map { |topic| link_to(topic, topic) }
    links = [ link_to("Trails", practice_path) ] +
      topics_links +
      [ link_to(trail, trail) ]

    links.join(" #{separator} ").html_safe
  end

  def completeable_link(completeable, &block)
    if completeable.is_a?(Exercise)
      link_to completeable.url, title: completeable.name, &block
    else
      link_to completeable, title: completeable.name, &block
    end
  end

  def trail_call_to_action(trail)
    if current_user.subscriber?
      start_trail_link(trail.first_completeable)
    elsif current_user.sampler?
      or_visit_trail(trail) { |video| start_trail_link(video) }
    else
      or_visit_trail(trail) { |video| auth_to_access_button(video) }
    end
  end

  def or_visit_trail(trail)
    trail.sample_video.map { |video|
      yield video
    }.unwrap_or(
      visit_trail_link(trail)
    )
  end

  def start_trail_link(url)
    link_to(
      t("trails.start_trail"),
      url,
      class: "start-trail cta-button small-button",
    )
  end

  def visit_trail_link(trail)
    link_to(
      t("trails.visit_trail"),
      trail,
      class: "cta-button small-button",
    )
  end

  def auth_to_access_button(video, cta_text: t("trails.start_for_free"))
    cta_classes = "cta-button subscribe-cta light-bg"
    link_to video_auth_to_access_path(video), class: cta_classes do
      image_tag("github-black.svg", class: "logo", alt: "") + cta_text
    end
  end
end
