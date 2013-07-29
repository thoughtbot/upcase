xml.item do
  xml.title episode.full_title
  xml.link show_episode_url(episode.show, episode)
  if episode.old_url.blank?
    xml.guid show_episode_url(episode.show, episode)
  else
    xml.guid episode.old_url
  end
  xml.pubDate episode.rss_pub_date
  xml.author 'thoughtbot'
  xml.description episode.description
  xml.enclosure url: show_episode_url(episode.show, episode, format: :mp3), length: episode.file_size, type: 'audio/mpeg'
  xml.duration episode.duration
  xml.tag! 'content:encoded', "<p>#{episode.description}</p>" + BlueCloth.new(episode.notes).to_html
  xml.tag! 'itunes:author', 'thoughtbot'
  xml.tag! 'itunes:subtitle', episode.description
  xml.tag! 'itunes:summary', episode.description
  xml.tag! 'itunes:keywords', episode.show.keywords
  xml.tag! 'itunes:image', href: "http://gr-podcast.s3.amazonaws.com/#{episode.show.slug}-1400.jpg"
end
