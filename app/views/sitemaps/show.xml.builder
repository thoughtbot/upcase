xml.instruct! :xml, version: "1.0"

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc "https://upcase.com/"
    xml.priority "1.0"
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
      xml.priority "0.6"
    end
  end

  xml.url do
    xml.loc "https://upcase.com/pages/privacy"
    xml.changefreq "yearly"
    xml.priority "0.2"
  end

  xml.url do
    xml.loc "https://upcase.com/pages/terms"
    xml.changefreq "yearly"
    xml.priority "0.2"
  end
end
