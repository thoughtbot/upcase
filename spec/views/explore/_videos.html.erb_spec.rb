require "rails_helper"

describe "explore/_videos.html" do
  context "with a published episode" do
    it "renders the video" do
      latest_video = build_stubbed(:video)
      show = build_stubbed(:show)
      show.stubs(:latest_video).returns(latest_video)
      video_tutorial = build_stubbed(:video_tutorial)

      render "explore/videos", show: show, video_tutorial: video_tutorial

      expect(rendered).to have_text(show.tagline)
      expect(rendered).to have_text(latest_video.title)
    end
  end

  context "with no published episodes" do
    it "skips the video" do
      show = build_stubbed(:show)
      show.stubs(:latest_video).returns(nil)
      video_tutorial = build_stubbed(:video_tutorial)

      render "explore/videos", show: show, video_tutorial: video_tutorial

      expect(rendered).not_to have_text(show.tagline)
    end
  end
end
