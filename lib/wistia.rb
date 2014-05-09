class Wistia
  include HTTParty
  base_uri 'https://api.wistia.com/v1'
  basic_auth 'api', ENV['WISTIA_API_KEY']

  def self.get_media_hash_from_id id
    get("/medias/#{id}.json").body
  rescue *HTTP_ERRORS => e
    Airbrake.notify e
    {}
  end
end
