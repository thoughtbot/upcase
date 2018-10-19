require "rails_helper"

describe DownloadsController do
  include StubCurrentUserHelper

  describe "#show" do
    it "should respond with a redirect to the clip download URL" do
      stub_current_user_with(build_stubbed(:user))
      video = create(:video)

      get :show, params: { clip_id: video.wistia_id, download_type: "original" }

      expect(response).to redirect_to video.download_url("original")
    end

    it "should track the downloaded event" do
      stub_current_user_with(build_stubbed(:user))
      video = create(:video)

      get :show, params: { clip_id: video.wistia_id, download_type: "original" }

      expect(analytics).to(
        have_tracked("Downloaded Video").
        with_properties(
          name: video.name,
          watchable_name: video.watchable_name,
          download_type: "original",
        )
      )
    end
  end
end
