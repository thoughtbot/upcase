require "rails_helper"

include StubCurrentUserHelper

describe VideosController do
  describe "#show when viewing a video as user with access" do
    it "renders the subscriber view so they can watch video" do
      user = create(:subscriber)
      video = create(:video)
      stub_current_user_with(user)

      get :show, id: video

      expect(response).to render_template "show_for_subscribers"
    end

    it "doesn't recognize other formats" do
      expect do
        get :show, id: create(:video), format: :json
      end.to raise_exception(ActionController::UnknownFormat)
    end
  end

  describe "#show when viewing a video with preview without access" do
    it "renders show" do
      video = create(:video, :with_preview)

      get :show, id: video

      expect(response).to render_template "show_for_visitors"
    end
  end

  describe "#show when viewing a video without a preview without access" do
    it "renders show" do
      show = create(:show)
      video = create(:video, watchable: show)

      get :show, id: video

      expect(response).to redirect_to show_url(show)
    end
  end
end
