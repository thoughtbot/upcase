xml.item do
  xml.description video_description(video)
  xml.guid video_url(video)
  xml.link video_url(video)
  xml.pubDate video.created_at.to_s(:rfc822)
  xml.title video.title
end
