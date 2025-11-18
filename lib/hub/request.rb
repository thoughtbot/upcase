module Hub
  class Request
    # https://github.com/thoughtbot/hub/blob/main/doc/api/restful/README.md#all-requests
    REQUEST_HEADERS = {
      "Accept" => "application/vnd.hub+json; version=1",
      "Authorization" => "Token token=#{Hub.config.token}"
    }.freeze

    def post(...)
      response = connection.post(...)

      unless response.success?
        raise ActionController::RoutingError, response.reason_phrase
      end

      response.body
    end

    private

    def connection
      Faraday.new(url: Hub.config.url, headers: REQUEST_HEADERS) do |connection|
        connection.request :json
        connection.response :json
      end
    end
  end
end
