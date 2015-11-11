require "rails_helper"

describe "videos/_video_for_trail_preview.html" do
  include Rails.application.routes.url_helpers

  context "with access to the video" do
    it "links to the video page" do
      stub_access true
      video = build_stubbed(:video, :with_progress)

      render "videos/video_for_trail_preview", video: video

      expect(rendered).to have_link_to(video_path(video))
    end
  end

  context "without access to a subscription-only video" do
    it "links to the join page" do
      stub_access false
      video = build_stubbed(
        :video,
        :with_progress,
        accessible_without_subscription: false,
      )

      render "videos/video_for_trail_preview", video: video

      expect(rendered).to have_link_to(join_path)
    end
  end

  context "without access to a video accessible without a subscription" do
    it "links to the auth to access path" do
      stub_access false
      video = create(
        :video,
        :with_progress,
        accessible_without_subscription: true,
      )

      render "videos/video_for_trail_preview", video: video

      expect(rendered).to have_link_to(video_auth_to_access_path(video))
    end
  end

  def stub_access(result)
    view_stubs(:current_user_has_access_to?).and_return(result)
  end
end
