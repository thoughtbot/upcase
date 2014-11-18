require "rails_helper"

describe VideosHelper do
  describe "#video_description" do
    it "returns plain text video notes" do
      video = stub("video", notes_html: "<h1>Citizen Kane</h1>")

      result = video_description(video)

      expect(result).to eq "Citizen Kane"
    end

    it "truncates the video notes to 250 characters by default" do
      video = stub("video", notes_html: "D" * 251)

      result = video_description(video)

      expect(result.length).to eq 250
    end

    it "truncates the video notes to the given character length" do
      video = stub("video", notes_html: "D" * 201)

      result = video_description(video, length: 200)

      expect(result.length).to eq 200
    end
  end
end
