module Hub
  class Request
    def post(...)
      response = connection.post(...)

      unless response.success?
        raise ActionController::RoutingError, response.reason_phrase
      end

      response.body
    end

    private

    def connection
      Faraday.new(
        url: Hub.config.url,
        # https://github.com/thoughtbot/hub/blob/main/doc/api/restful/README.md#all-requests
        headers: {
          "Accept" => "application/vnd.hub+json; version=1",
          "Authorization" => "Token token=#{Hub.config.token}"
        }
      ) do |connection|
        connection.request :json
        connection.response :json
      end
    end
  end
end
