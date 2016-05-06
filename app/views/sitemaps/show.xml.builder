xml.instruct! :xml, version: "1.0"

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc url_with_path_prefix
    xml.priority "1.0"
  end

  xml.url do
    xml.loc show_url(@weekly_iteration)
    xml.lastmod @weekly_iteration.updated_at.to_date
    xml.priority "0.8"
  end

  @topics.each do |topic|
    xml.url do
      xml.loc topic_url(topic)
      xml.lastmod topic.updated_at.to_date
      xml.priority "0.8"
    end
  end

  @trails.each do |trail|
    xml.url do
      xml.loc trail_url(trail)
      xml.lastmod trail.updated_at.to_date
      xml.priority "0.8"
    end
  end

  @videos.each do |video|
    xml.url do
      xml.loc video_url(video)
      xml.lastmod video.updated_at.to_date
      xml.priority "0.8"
    end
  end

  xml.url do
    xml.loc "#{url_with_path_prefix}/pages/privacy"
    xml.changefreq "yearly"
    xml.priority "0.2"
  end

  xml.url do
    xml.loc "#{url_with_path_prefix}/pages/terms"
    xml.changefreq "yearly"
    xml.priority "0.2"
  end
end
