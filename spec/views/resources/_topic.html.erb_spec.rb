require "rails_helper"

describe "resources/_topic" do
  it "shows videos and video tutorials" do
    render_topic

    expect(rendered).to include("The Weekly Iteration")
    expect(rendered).to include("Video Tutorials")
  end

  context "with published trails" do
    it "renders the published trails header" do
      render_topic published_trails: [build_stubbed(:trail)]

      expect(rendered).to have_trails_header
    end
  end

  context "with only unpublished trails" do
    it "doesn't render the published trails header" do
      render_topic published_trails: []

      expect(rendered).not_to have_trails_header
    end
  end

  def render_topic(**topic_attributes)
    topic = topic_with_resources(**topic_attributes)
    view_stubs(:current_user)
    stub_template("practice/_trail.html.erb" => "")
    render partial: "resources/topic", locals: { topic: topic }
  end

  def topic_with_resources(published_trails: [])
    build_stubbed(
      :topic,
      videos: [build_stubbed(:video, slug: "a-video")],
      video_tutorials: [build_stubbed(:video_tutorial)]
    ).tap do |topic|
      allow(topic).to receive(:published_trails).and_return(published_trails)
    end
  end

  def have_trails_header
    have_text("All Trails")
  end
end
