require "rails_helper"

describe "resources/_topic" do
  it "shows videos and video tutorials" do
    view_stubs(:current_user)

    render partial: "resources/topic", locals: { topic: topic_with_resources }

    expect(rendered).to include("The Weekly Iteration")
    expect(rendered).to include("Video Tutorials")
  end

  def topic_with_resources
    build_stubbed(
      :topic,
      videos: [build_stubbed(:video, slug: "a-video")],
      video_tutorials: [build_stubbed(:video_tutorial)]
    )
  end
end
