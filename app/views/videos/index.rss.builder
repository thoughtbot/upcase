xml.instruct! :xml, version: '1.0'

xml.rss version: '2.0' do
  xml.channel do
    xml.description "Improve your programming skills with focused exercises."
    xml.link root_url
    xml.title "Upcase Videos"

    xml << render(@videos)
  end
end
