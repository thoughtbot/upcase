module WistiaApiClient
  class Media
    WISTIA_API_URL = ENV.fetch("WISTIA_API_HOST")
    DEFAULT_API_TOKEN = ENV.fetch("WISTIA_API_KEY")

    def initialize(api_token: DEFAULT_API_TOKEN)
      @api_token = api_token
    end

    def list(limit: 100, starting_page: 1)
      uri = URI("#{WISTIA_API_URL}/medias.json")
      list_response(uri: uri, page: starting_page, limit: limit)
    end

    def show(wistia_id)
      uri = URI("#{WISTIA_API_URL}/medias/#{wistia_id}.json")
      request = make_request(uri: uri)
      JSON.parse(request.body)
    end

    private

    attr_reader :api_token

    def list_response(uri:, limit: 100, page: 1)
      uri.query = "page=#{page}&limit=#{limit}"
      response = make_request(uri: uri)

      parsed_response = JSON.parse(response.body)

      if parsed_response.blank?
        []
      else
        parsed_response + list_response(uri: uri, page: page + 1, limit: limit)
      end
    end

    def make_request(uri:)
      request = Net::HTTP::Get.new(uri)
      request.basic_auth("api", api_token)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.request(request)
    end
  end
end
