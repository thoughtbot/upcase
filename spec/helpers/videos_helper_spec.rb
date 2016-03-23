require "rails_helper"

describe VideosHelper do
  describe "#topic_slugs" do
    it "returns nil if no related topic found" do
      video = double("video", topics: [])

      result = topic_slugs(video)

      expect(result).to be_nil
    end

    it "returns parameterized slug of related topic when found" do
      topic = double("topic", slug: "test-driven+development")
      video = double("video", topics: [topic])

      result = topic_slugs(video)

      expect(result).to eq("test-driven-development")
    end
  end
end
