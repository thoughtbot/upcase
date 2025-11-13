require "rails_helper"
require "openssl"

RSpec.describe WistiaApiClient::Media do
  describe "#list" do
    it "returns a parsed JSON response" do
      pending "needs mocking"

      media_client = described_class.new

      mock_wistia_api_response_with(
        uri: "https://api.wistia.com/v1/medias.json?limit=100&page=1",
        response: {
          body: {hi: "there"}.to_json
        }
      )

      result = media_client.list

      expect(result).to respond_to :each
      expect(result.first).to respond_to :keys
    end

    it "combines multi-page responses into a single response" do
      pending "needs mocking"

      media_client = described_class.new

      result = media_client.list(limit: 1, starting_page: 1)

      expect(result.size).to eq 3
    end
  end

  describe "#show" do
    it "returns a parsed JSON response for a single media object" do
      pending "needs mocking"

      media_client = described_class.new
      wistia_id = "123foo"

      result = media_client.show(wistia_id)

      expect(result["type"]).to eq "Video"
      expect(result.keys).to include("name", "duration", "hashed_id")
    end
  end

  def mock_wistia_api_response_with(uri:, response: {})
    mock_response = { body: "", headers: {} }.merge(response)

    stub_request(:get, uri)
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic YXBpOmFwaV9rZXk=',
          'Host'=>'api.wistia.com',
          'User-Agent'=>'Ruby'
        }
      )
      .to_return(
        status: 200,
        body: mock_response.fetch(:body),
        headers: mock_response.fetch(:headers)
      )
  end
end
