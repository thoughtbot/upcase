require "rails_helper"

RSpec.describe VideoThumbnail do
  context "#url" do
    it "returns the url" do
      wistia_id = double("wista_id")
      clip = double("clip", wistia_id: wistia_id)
      thumbnail = VideoThumbnail.new(clip)

      expect(thumbnail.wistia_id).to eq wistia_id
    end
  end
end
