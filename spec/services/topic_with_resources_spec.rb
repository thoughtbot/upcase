require "rails_helper"

describe TopicWithResources do
  describe "#name" do
    it "delegates to its topic" do
      name = "some-name"
      topic = Topic.new(name: name)
      topic_with_resources =
        TopicWithResources.new(topic, resources: double("resources"))

      result = topic_with_resources.name

      expect(result).to eq(name)
    end
  end

  describe "#resources" do
    it "sorts its resources by creation" do
      resources = [
        double("two", created_at: 2.days.ago, name: "two"),
        double("one", created_at: 1.day.ago, name: "one"),
        double("three", created_at: 3.days.ago, name: "three")
      ]
      topic = Topic.new
      topic_with_resources = TopicWithResources.new(topic, resources: resources)

      result = topic_with_resources.resources

      expect(result.map(&:name)).to eq(%w(one two three))
    end
  end

  describe "#count" do
    it "counts the number of resources" do
      resources = [
        double("two", created_at: 2.days.ago),
        double("one", created_at: 1.day.ago),
        double("three", created_at: 3.days.ago),
        double("four", created_at: 4.days.ago)
      ]
      topic = Topic.new
      topic_with_resources = TopicWithResources.new(topic, resources: resources)

      result = topic_with_resources.count

      expect(result).to eq(4)
    end
  end
end
