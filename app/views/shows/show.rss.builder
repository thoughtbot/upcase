xml.instruct! :xml, version: '1.0'

xml.rss version: '2.0' do
  xml.channel do
    xml.description @offering.short_description
    xml.link show_url(@offering)
    xml.title @offering.name

    xml << render(@offering.published_videos.ordered)
  end
end
