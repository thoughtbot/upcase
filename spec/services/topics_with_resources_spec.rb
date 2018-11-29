require "rails_helper"

describe TopicsWithResources do
  it "is Enumerable" do
    factory = double("factory")
    topics = double("topics")
    resources = TopicsWithResources.new(topics: topics, factory: factory)

    expect(resources).to be_a(Enumerable)
  end

  describe "#each" do
    it "yields topics with resources" do
      topics = [double("topic"), double("topic")]
      decorated = double("decorated")
      factory = spy("factory")
      allow(factory).to receive(:decorate).and_return(decorated)
      resources = TopicsWithResources.new(topics: topics, factory: factory)
      result = []

      resources.each { |yielded| result << yielded }

      expect(result).to eq([decorated, decorated])
      topics.each do |topic|
        expect(factory).to have_received(:decorate).with(topic)
      end
    end
  end

  describe "#find" do
    it "finds resources for a given topic" do
      topic = double("topic")
      topic_slug = double("topic_slug")
      topics = double("topics")
      allow(topics).to receive(:find_by!).with(slug: topic_slug).
        and_return(topic)
      decorated = double("decorated")
      factory = double("factory")
      allow(factory).to receive(:decorate).with(topic).and_return(decorated)
      resources = TopicsWithResources.new(topics: topics, factory: factory)

      result = resources.find(topic_slug)

      expect(result).to eq(decorated)
    end
  end
end
