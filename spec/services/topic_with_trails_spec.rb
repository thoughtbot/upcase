require "rails_helper"

describe TopicWithTrails do
  describe "#name" do
    it "finds topic by slug and delegates to it" do
      topic = create(:topic, :explorable)
      user = double("user")
      topic_with_trails = TopicWithTrails.new(topic_slug: topic.slug, user: user)

      expect(topic_with_trails).to be_kind_of(SimpleDelegator)
      expect(topic_with_trails.id).to eq(topic.id)
    end
  end

  describe "#published_trails" do
    it "returns related TrailsWithProgress" do
      unpublished_trail = create(:trail)
      published_trail = create(:trail, :published)
      topic_with_trails = create_topic_with_trails(
        [unpublished_trail, published_trail]
      )

      trails = topic_with_trails.published_trails

      expect(trails.count).to eq(1)
      expect(trails.first).to be_kind_of(TrailWithProgress)
      expect(trails.first.id).to eq(published_trail.id)
    end
  end

  def create_topic_with_trails(trails)
    topic = create(:topic, :explorable, trails: trails)
    user = double("user")
    TopicWithTrails.new(topic_slug: topic.slug, user: user)
  end
end
