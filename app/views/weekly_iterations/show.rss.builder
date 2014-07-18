xml.instruct! :xml, version: '1.0'

xml.rss version: '2.0' do
  xml.channel do
    xml.description @show.short_description
    xml.link weekly_iteration_url
    xml.title @show.name

    @show.published_videos.ordered.each do |video|
      xml.item do
        xml.description truncate(strip_tags(video.notes_html), length: 250)
        xml.guid video_url(video)
        xml.link video_url(video)
        xml.pubDate video.created_at.to_s(:rfc822)
        xml.title video.title
      end
    end
  end
end
