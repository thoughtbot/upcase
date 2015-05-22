require "rails_helper"

describe "videos/show_for_subscribers" do
  context "when the video is part of a trail" do
    it "displays the progress bar" do
      video = create(:video, :with_trail)

      render_video video

      expect(rendered).to have_progress_bar
    end
  end

  context "when the video is part of a show, not a trail" do
    it "does not display a trail progress bar" do
      video = create(:video, :published, watchable: create(:show))

      render_video video

      expect(rendered).not_to have_progress_bar
    end
  end

  def render_video(video)
    assign :video, video
    view_stubs(:current_user).and_return(build_stubbed(:user))
    view_stubs(:current_user_has_access_to?).and_return(true)
    render template: "videos/show_for_subscribers"
  end

  def have_progress_bar
    have_css(".trails-progress")
  end
end
