require "rails_helper"

describe "videos/_video_player" do
  include VideoHelpers

  describe "trail progress bar" do
    context "when the video is part of a trail" do
      it "displays the progress bar" do
        video = create_video_on_a_trail

        render_video_player video

        expect(rendered).to have_progress_bar
      end
    end

    context "when the video is part of a show, not a trail" do
      it "does not display a trail progress bar" do
        video = create(:video, watchable: create(:show))

        render_video_player video

        expect(rendered).not_to have_progress_bar
      end
    end
  end

  def render_video_player(video)
    user = build_stubbed(:user)
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:current_user_has_access_to?).and_return(false)
    render template: "videos/_video_player", locals: { video: video }
  end

  def have_progress_bar
    have_css(".trails-progress")
  end
end
