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

  describe "#upcase_video_url" do
    it "returns a video url as though it were still on upcase.com" do
      video = double("video", to_s: "test-video")

      result = upcase_video_url(video)

      expect(result).to_not include("/upcase")
    end
  end
end
