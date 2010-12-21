require "rack"

module ShamRack

  # A simple Rack app that stubs out a web service, for testing.
  class StubWebService

    def initialize
      @handlers = []
    end

    def last_request
      @request
    end

    def call(env)
      @request = Rack::Request.new(env)
      @handlers.each do |handler|
        response = handler.call(@request)
        return response if response
      end
      return default_response
    end

    def handle(&block)
      @handlers.unshift(block)
    end

    def register_resource(path, content, content_type = "application/xml", status = 200)
      handle do |request|
        request_path = request.path_info
        unless request.query_string.to_s.empty?
          request_path += "?" + request.query_string
        end
        [status, {"Content-Type" => content_type}, content] if request_path == path
      end
    end

    def reset
      @handlers.clear
    end

    protected

    def default_response
      [404, {"Content-Type" => "text/plain"}, "Not found"]
    end

  end

end
