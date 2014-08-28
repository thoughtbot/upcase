require "rails_helper"

describe TopicsWithResources do
  it "is Enumerable" do
    factory = stub("factory")
    topics = stub("topics")
    resources = TopicsWithResources.new(topics: topics, factory: factory)

    expect(resources).to be_a(Enumerable)
  end

  describe "#each" do
    it "yields topics with resources" do
      topics = [stub("topic"), stub("topic")]
      decorated = stub("decorated")
      factory = stub("factory")
      factory.stubs(:decorate).returns(decorated)
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
      topic = stub("topic")
      topic_slug = stub("topic_slug")
      topics = stub("topics")
      topics.stubs(:find_by_slug!).with(topic_slug).returns(topic)
      decorated = stub("decorated")
      factory = stub("factory")
      factory.stubs(:decorate).with(topic).returns(decorated)
      resources = TopicsWithResources.new(topics: topics, factory: factory)

      result = resources.find(topic_slug)

      expect(result).to eq(decorated)
    end
  end
end
