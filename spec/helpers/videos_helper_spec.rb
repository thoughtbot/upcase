require "rails_helper"

describe VideosHelper do
  include ApplicationHelper

  describe "#video_description" do
    it "returns plain text video notes" do
      video = double("video", notes: "# Vim's Power")

      result = video_description(video)

      expect(result).to eq "Vim's Power"
    end

    it "truncates the video notes to 250 characters by default" do
      video = double("video", notes: "D" * 251)

      result = video_description(video)

      expect(result.length).to eq 250
    end

    it "truncates the video notes to the given character length" do
      video = double("video", notes: "D" * 201)

      result = video_description(video, length: 200)

      expect(result.length).to eq 200
    end
  end

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
