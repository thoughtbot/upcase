require "spec_helper"

describe VideoWithStatus do
  describe "status_class" do
    it "paremterizes the provided status' state" do
      status = double(Status, state: "In Progress")

      video_with_status = VideoWithStatus.new(double, status)

      expect(video_with_status.status_class).to eq "in-progress"
    end
  end
end
