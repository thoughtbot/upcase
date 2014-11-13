xml.item do
  xml.description truncate(strip_tags(video.notes_html), length: 250)
  xml.guid video_url(video)
  xml.link video_url(video)
  xml.pubDate video.created_at.to_s(:rfc822)
  xml.title video.title
end
