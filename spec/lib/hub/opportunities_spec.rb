require "rails_helper"

describe Hub::Opportunities do
  describe ".create" do
    it "makes a POST request to the Hub API with the correct body" do
      allow(Hub.config).to receive(:url).and_return("https://hub.thoughtbot.com/api")
      expected_request =
        stub_request(:post, "https://hub.thoughtbot.com/api/opportunities")
          .with(body: {opportunity: {email: "example@example.com"}})
          .to_return_json(body: {"opportunity" => {"id" => 1}})

      described_class.create({email: "example@example.com"})

      expect(expected_request).to have_been_requested
    end
  end
end
