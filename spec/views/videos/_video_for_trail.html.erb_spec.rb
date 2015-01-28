require "rails_helper"

describe "videos/_video_for_trail.html" do
  it "titles the tooltip with Video" do
    stub_user
    video = stub_video(state: "unstarted")

    render "videos/video_for_trail", video: video

    expect(rendered).to have_content("Video")
    expect(rendered).not_to have_content("Exercise")
  end

  def stub_user
    view_stubs(:current_user_has_access_to?).returns(true)
    build_stubbed(:user).tap do |user|
      view_stubs(:current_user).returns(user)
    end
  end

  def stub_video(state: "Imaginary")
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      build_stubbed(:video).tap do |video|
        video.stubs(:can_be_accessed?)
        video.stubs(:state).returns(state)
      end
    end
  end
end
