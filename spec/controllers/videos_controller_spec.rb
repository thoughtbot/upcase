require "rails_helper"

include StubCurrentUserHelper

describe VideosController do
  describe "#show" do
    context "when viewing a video as user with access" do
      it "renders the subscriber view so they can watch video" do
        user = create(:subscriber)
        video = create(:video)
        stub_current_user_with(user)

        get :show, id: video

        expect(response).to render_template "show_for_subscribers"
      end
    end

    context "when viewing a video the user does not have access to" do
      it "renders the version intended for visitors" do
        video = create(:video)

        get :show, id: video

        expect(response).to render_template "show_for_visitors"
      end
    end
  end

  it "doesn't recognize other formats" do
    expect do
      get :show, id: create(:video), format: :json
    end.to raise_exception(ActionController::UnknownFormat)
  end
end
