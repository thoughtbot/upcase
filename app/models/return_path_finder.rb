# Parses a URL for a `return_to` path
class ReturnPathFinder
  def initialize(url)
    @url = url
  end

  def return_path
    query_string["return_to"]
  end

  private

  attr_reader :url

  def query_string
    Rack::Utils.parse_nested_query(parsed_url.query)
  end

  def parsed_url
    URI.parse(url)
  end
end
