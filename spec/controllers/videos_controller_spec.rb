require "rails_helper"

include StubCurrentUserHelper

describe VideosController do
  describe "#show" do
    context "when the viewer has an active subscription" do
      it "renders the subscriber view so they can watch video" do
        user = create(:subscriber)
        video = create(:video)
        stub_current_user_with(user)

        get :show, id: video

        expect(response).to render_template "show_for_subscribers"
      end
    end

    context "without an active subscription" do
      context "when viewing a weekly iteration video" do
        it "renders the visitor version of the view" do
          video = create(:video, watchable: create(:the_weekly_iteration))

          get :show, id: video

          expect(response).to render_template "show_for_visitors"
        end
      end

      context "when viewing a trail video" do
        it "redirects the user to sign_in" do
          video = create_video_on_trail

          get :show, id: video.id

          expect(response).to redirect_to(sign_in_path)
        end
      end
    end
  end

  it "doesn't recognize other formats" do
    expect do
      get :show, id: create(:video), format: :json
    end.to raise_exception(ActionController::UnknownFormat)
  end

  def create_video_on_trail
    trail = create(:trail, name: "Trail")
    create(:video).tap do |video|
      create(:step, trail: trail, completeable: video)
    end
  end
end
