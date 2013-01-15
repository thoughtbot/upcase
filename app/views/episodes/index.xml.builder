xml.instruct!
xml.rss :version => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:sy' => 'http://purl.org/rss/1.0/modules/syndication/', 'xmlns:admin' => "http://webns.net/mvcb/", 'xmlns:atom' => 'http://www.w3.org/2005/Atom/', 'xmlns:rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'xmlns:content' => 'http://purl.org/rss/1.0/modules/content/', 'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd' do
  xml.channel do
    xml.title 'Giant Robots Smashing into other Giant Robots'
    xml.link href: 'http://thoughtbot.com/podcast'
    if @episodes.any?
      xml.pubDate @episodes.first.published_on.to_s(:rfc822)
    end
    xml.description "A weekly technical podcast discussing development, design, and the business of software development."
    xml.language 'en-us'
    xml.tag! 'itunes:new-feed-url', 'http://learn.thoughtbot.com/podcast.xml'
    xml.tag! 'itunes:subtitle', 'Giant Robots Smashing into other Giant Robots'
    xml.tag! 'itunes:author', 'thoughtbot'
    xml.tag! 'itunes:summary', 'Giant Robots Smashing into other Giant Robots is a weekly technical podcast discussing development, design, and the business of software development.'
    xml.tag! 'itunes:image', href: 'http://gr-podcast.s3.amazonaws.com/podcastlogo.png'
    xml.tag! 'itunes:keywords', 'design, development, software'
    xml.tag! 'itunes:explicit', 'no'
    xml.tag! 'itunes:owner' do
      xml.tag! 'itunes:name', 'thoughtbot'
      xml.tag! 'itunes:email', 'info@thoughtbot.com'
    end
    xml.tag! 'itunes:category', text: 'Technology' do
      xml.tag! 'itunes:category', text: 'software How-To'
    end

    @episodes.each do |episode|
      xml.item do
        xml.title episode.full_title
        xml.link episode_url(episode)
        xml.guid episode.old_url.blank? ? episode_url(episode) : episode.old_url
        xml.pubDate episode.published_on.to_s(:rfc822)
        xml.author 'thoughtbot'
        xml.description episode.description
        xml.enclosure url: episode_url(episode, format: :mp3), length: episode.file_size, type: 'audio/mpeg'
        xml.duration episode.duration
        xml.tag! 'content:encoded', "<p>#{episode.description}</p>" + BlueCloth.new(episode.notes).to_html
        xml.tag! 'itunes:author', 'thoughtbot'
        xml.tag! 'itunes:subtitle', episode.description
        xml.tag! 'itunes:summary', episode.description
        xml.tag! 'itunes:keywords', 'design, development, software'
        xml.tag! 'itunes:image', href: 'http://gr-podcast.s3.amazonaws.com/podcastlogo.png'
      end
    end
  end
end
