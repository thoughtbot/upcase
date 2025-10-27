require "rails_helper"

RSpec.describe "trails/_progress_dots" do
  include Rails.application.routes.url_helpers
  include TrailHelpers

  it "applies a class to indicate the state of the exercise" do
    stub_current_user_has_access
    completeable = build_completeable_with_progress(state: Status::COMPLETE)

    render "trails/progress_dot", completeable: completeable

    expect(rendered).to have_css(".complete-exercise")
  end

  context "when the user has access to the completeable" do
    it "renders the dot as a link to the completeable" do
      stub_current_user_has_access(true)
      video = build_completeable_with_progress

      render "trails/progress_dot", completeable: video

      expect(rendered).to have_link(video.name, href: video_path(video))
    end
  end

  context "when the user has access to the completeable" do
    it "renders the dot as a link to the completeable" do
      stub_current_user_has_access(false)
      video = build_completeable_with_progress

      render "trails/progress_dot", completeable: video

      expect(rendered).not_to have_link(video.name, href: video_path(video))
    end
  end

  def stub_current_user_has_access(has_access = false)
    view_stubs(:current_user_has_access_to?).and_return(has_access)
  end
end
