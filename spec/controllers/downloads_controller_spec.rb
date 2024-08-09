require "rails_helper"

describe DownloadsController do
  include StubCurrentUserHelper

  describe "#show" do
    it "should respond with a redirect to the clip download URL" do
      stub_current_user_with(build_stubbed(:user))
      video = create(:video)

      get :show, params: {clip_id: video.wistia_id, download_type: "original"}

      expect(response).to redirect_to video.download_url("original")
    end
  end
end
