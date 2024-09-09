require "rails_helper"

describe VideosController do
  include StubCurrentUserHelper

  describe "#show" do
    context "when the video is part of the weekly iteration" do
      it "renders the view" do
        video = create(:video, watchable: create(:the_weekly_iteration))

        get :show, params: {id: video}

        expect(response).to render_the_show_view
      end
    end

    context "when the video is part of a trail" do
      context "and the user is logged in" do
        it "renders the view" do
          stub_current_user_with(create(:user))
          video = create_video_on_trail

          get :show, params: {id: video}

          expect(response).to render_the_show_view
        end
      end

      context "when the user is logged out" do
        it "renders the view" do
          video = create_video_on_trail

          get :show, params: {id: video}

          expect(response).to render_the_show_view
        end
      end
    end

    context "when video slug is used for param" do
      it "renders the view" do
        stub_current_user_with(build_stubbed(:user))
        video = create_video_on_trail

        get :show, params: {id: video.slug}

        expect(response).to render_the_show_view
      end
    end

    context "when video id is used for param" do
      it "redirects to video slug version" do
        stub_current_user_with(build_stubbed(:user))
        video = create_video_on_trail

        get :show, params: {id: video.id}

        expect(response).to redirect_to video_path(video.slug)
      end
    end
  end

  it "doesn't recognize other formats" do
    expect do
      get :show, params: {id: create(:video)}, format: :json
    end.to raise_exception(ActionController::UnknownFormat)
  end

  def render_the_show_view
    render_template "show"
  end

  def create_video_on_trail
    trail = create(:trail, name: "Trail")
    create(:video).tap do |video|
      create(:step, trail: trail, completeable: video)
    end
  end
end
