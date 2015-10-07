xml.item do
  xml.title video.name
  xml.description type: "html" do |desc|
    desc.cdata!(format_markdown(video.summary))
  end
  xml.guid video_url(video)
  xml.link video_url(video)
  xml.pubDate video.created_at.to_s(:rfc822)
end
