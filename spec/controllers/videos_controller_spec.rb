require "rails_helper"

include StubCurrentUserHelper

describe VideosController do
  describe "#show" do
    context "when the video is part of the weekly iteration" do
      it "renders the view" do
        video = create(:video, watchable: create(:the_weekly_iteration))

        get :show, id: video

        expect(response).to render_the_show_view
      end
    end

    context "when the video is part of a trail" do
      context "and the user has an active subscription" do
        it "renders the view" do
          stub_current_user_with(create(:subscriber))
          video = create_video_on_trail

          get :show, id: video

          expect(response).to render_the_show_view
        end
      end

      context "when the user is a 'sampler'" do
        context "and the video is a free sample" do
          it "renders the view" do
            stub_current_user_with(build_stubbed(:user))
            video = create_video_on_trail(free_sample: true)

            get :show, id: video

            expect(response).to render_the_show_view
          end
        end

        context "and the video is not a free sample" do
          it "redirects with 'login required' notice" do
            stub_current_user_with(build_stubbed(:user))
            video = create_video_on_trail(free_sample: false)

            get :show, id: video

            expect(response).to redirect_to_sign_in_path
          end
        end
      end

      context "when the user is logged out" do
        it "redirects" do
          video = create_video_on_trail

          get :show, id: video

          expect(response).to redirect_to_sign_in_path
        end
      end
    end
  end

  it "doesn't recognize other formats" do
    expect do
      get :show, id: create(:video), format: :json
    end.to raise_exception(ActionController::UnknownFormat)
  end

  def render_the_show_view
    render_template "show"
  end

  def redirect_to_sign_in_path
    redirect_to sign_in_path
  end

  def create_video_on_trail(free_sample: false)
    trail = create(:trail, name: "Trail")
    create(:video, accessible_without_subscription: free_sample).tap do |video|
      create(:step, trail: trail, completeable: video)
    end
  end
end
