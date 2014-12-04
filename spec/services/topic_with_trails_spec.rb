require "rails_helper"

describe TopicWithTrails do
  describe "#name" do
    it "finds topic by slug and delegates to it" do
      topic_with_trails = create_topic_with_trails([])

      expect(topic_with_trails).to be_kind_of(SimpleDelegator)
      expect(topic_with_trails.id).to eq(topic_with_trails.topic.id)
    end
  end

  describe "#trails" do
    it "returns related TrailsWithProgress" do
      trail = create(:trail)
      topic_with_trails = create_topic_with_trails([trail])

      result = topic_with_trails.trails.first

      expect(result).to be_kind_of(TrailWithProgress)
      expect(result.id).to eq(trail.id)
    end
  end

  def create_topic_with_trails(trails)
    topic = create(:topic, :explorable, trails: trails)
    user = stub
    TopicWithTrails.new(topic_slug: topic.slug, user: user)
  end
end
