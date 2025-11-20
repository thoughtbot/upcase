require "rails_helper"

describe Hub::Request do
  describe "#post" do
    it "makes a POST request to the Hub API with the correct headers and body" do
      allow(Hub.config).to receive(:url).and_return("https://hub.thoughtbot.com/api")
      allow(Hub.config).to receive(:token).and_return("fake_token")
      expected_request =
        stub_request(:post, "https://hub.thoughtbot.com/api/books")
          .with(
            headers: {
              "Accept" => "application/vnd.hub+json; version=1",
              "Authorization" => "Token token=fake_token"
            },
            body: {book: {title: "Example Title"}}
          )
          .to_return_json(body: {"book" => {"id" => 1}})

      described_class.new.post("books", {book: {title: "Example Title"}})

      expect(expected_request).to have_been_requested
    end
  end
end
