require "rails_helper"

describe "explore/_videos.html" do
  context "with a published episode" do
    it "renders the video" do
      latest_video = build_stubbed(:video)
      show = build_stubbed(:show)
      allow(show).to receive(:latest_video).and_return(latest_video)
      trail = build_stubbed(:trail)

      render "explore/videos", show: show, trail: trail

      expect(rendered).to have_text(show.tagline)
      expect(rendered).to have_text(latest_video.name)
    end
  end

  context "with no published episodes" do
    it "skips the video" do
      show = build_stubbed(:show)
      allow(show).to receive(:latest_video).and_return(nil)
      trail = build_stubbed(:trail)

      render "explore/videos", show: show, trail: trail

      expect(rendered).not_to have_text(show.tagline)
    end
  end
end
