require "rails_helper"

RSpec.describe "topics/show" do
  context "when there are published trails" do
    it "renders a section listing the trails" do
      trail_name = "A great trail"
      trail = build_trail(name: trail_name)
      topic = build_topic_with_published_trails([trail])

      render_topic(topic)

      expect(rendered).to have_trails_section
      expect(rendered).to have_css(".trail", text: trail_name)
    end
  end

  context "when there are no published trails" do
    it "renders nothing related to trails" do
      topic = build_stubbed(:topic)
      allow(topic).to receive(:published_trails).and_return([])

      render_topic topic

      expect(rendered).not_to have_trails_section
    end
  end

  context "when there are weekly iteration episdoes" do
    it "renders a section listing the videos" do
      video_name = "A great video about coding the tubes"
      topic = build_stubbed(:topic)
      video_listing = [stub_video_with_status(name: video_name)]

      render_topic(topic, video_listing: video_listing)

      expect(rendered).to have_weekly_iteration_section
      expect(rendered).to have_css(".tile.weekly-iteration", text: video_name)
    end
  end

  context "when there are no weekly iteration episdoes for the topic" do
    it "renders nothing related to the weekly iteration" do
      topic = build_stubbed(:topic)

      render_topic(topic)

      expect(rendered).not_to have_weekly_iteration_section
    end
  end

  def have_trails_section
    have_css(".divider", text: "Trails")
  end

  def have_weekly_iteration_section
    have_css(".divider", text: "The Weekly Iteration")
  end

  def render_topic(topic, video_listing: [])
    assign :topic, topic
    assign :video_listing, video_listing
    render template: "topics/show"
  end

  def build_trail(**trail_args)
    build_stubbed(:trail, **trail_args).tap do |trail|
      allow(trail).to receive(:complete?).and_return(false)
      allow(trail).to receive(:unstarted?).and_return(true)
      allow(trail).to receive(:steps_remaining).and_return(2)
    end
  end

  def build_topic_with_published_trails(trails)
    build_stubbed(:topic).tap do |topic|
      allow(topic).to receive(:published_trails).and_return(trails)
    end
  end

  def stub_video_with_status(**video_attributes)
    build_stubbed(:video, **video_attributes).tap do |video|
      allow(video).to receive(:status_class).and_return("complete")
    end
  end
end
