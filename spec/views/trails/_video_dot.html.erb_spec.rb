require "rails_helper"

describe "trails/_video_dot.html" do
  it "displays a link with the video name for the link title" do
    stub_user
    video_with_progress = build_video_with_progress(name: "My video title")

    render "trails/video_dot", video: video_with_progress

    expect(rendered).to have_css("a[title='My video title']")
  end

  def stub_user
    view_stubs(:current_user_has_access_to?).returns(true)
  end

  def build_video_with_progress(name:)
    CompleteableWithProgress.
      new(build_stubbed(:video, name: name), Status::NEXT_UP)
  end
end
