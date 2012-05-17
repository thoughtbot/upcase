class Wistia
  include HTTParty
  base_uri 'https://api.wistia.com/v1'
  basic_auth 'api', 'f08ff1c89190992df94fa4f3812d3bbb6d825576'

  def self.get_media_hash_from_id id
    self.get("/medias/#{id}.json")
  end
end

x=Wistia.get_media_hash_from_id(1194803)


