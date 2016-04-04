require "rails_helper"

describe Clip do
  context "#download_url" do
    it "returns the download url for the video" do
      video = Clip.new("123")

      url = video.download_url("original")
      expected_url = Clip::WISTIA_DOWNLOAD_BASE_URL + "123/download?asset=original"

      expect(url).to eq expected_url
    end
  end
end
