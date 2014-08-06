require "spec_helper"

include StubCurrentUserHelper

describe VideosController do
  describe "#show when viewing a video as user with a license" do
    it "renders the licensed show so they can watch video" do
      user = create(:subscriber)
      video = create(:video)
      create(:license, user: user, licenseable: video.watchable)
      controller.stubs(:signed_in?).returns(true)
      stub_current_user_with(user)

      get :show, id: video

      expect(response).to render_template "show_licensed"
    end
  end

  describe "#show when viewing a video with preview without a license" do
    it "renders the licensed show so they can watch video" do
      video = create(:video, :with_preview)

      get :show, id: video

      expect(response).to render_template "show"
    end
  end

  describe "#show when viewing a video without a preview without a license" do
    it "renders the licensed show so they can watch video" do
      video = create(:video)

      get :show, id: video

      expect(response).to redirect_to video.watchable
    end
  end
end
