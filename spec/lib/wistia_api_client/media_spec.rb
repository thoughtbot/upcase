require "rails_helper"
require "openssl"

RSpec.describe WistiaApiClient::Media do
  describe "#list" do
    it "returns a parsed JSON response" do
      media_client = described_class.new

      result = media_client.list

      expect(result).to respond_to :each
      expect(result.first).to respond_to :keys
    end

    it "combines multi-page responses into a single response" do
      media_client = described_class.new

      result = media_client.list(limit: 1, starting_page: 1)

      expect(result.size).to eq 3
    end
  end

  describe "#show" do
    it "returns a parsed JSON response for a single media object" do
      media_client = described_class.new
      wistia_id = "123foo"

      result = media_client.show(wistia_id)

      expect(result["type"]).to eq "Video"
      expect(result.keys).to include("name", "duration", "hashed_id")
    end
  end
end
