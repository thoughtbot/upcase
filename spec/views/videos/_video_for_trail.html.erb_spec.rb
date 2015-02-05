require "rails_helper"

describe "videos/_video_for_trail.html" do
  it "titles the tooltip with Video" do
    stub_user
    video_with_progress = build_video_with_progress(state: Status::UNSTARTED)

    render "videos/video_for_trail", video: video_with_progress

    expect(rendered).to have_content("Video")
    expect(rendered).not_to have_content("Exercise")
  end

  def stub_user
    view_stubs(:current_user_has_access_to?).and_return(true)
  end

  def build_video_with_progress(state:)
    CompleteableWithProgress.new(build_stubbed(:video), state)
  end
end
