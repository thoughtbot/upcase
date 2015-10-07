xml.instruct! :xml, version: '1.0'

xml.rss version: '2.0' do
  xml.channel do
    xml.description @show.short_description
    xml.link show_url(@show)
    xml.title @show.name

    xml << render(@show.published_videos.recently_published_first.first(10))
  end
end
