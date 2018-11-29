# High-level interface for combining Topics with related resources using a
# decorator factory.
class TopicsWithResources
  include Enumerable

  def initialize(factory:, topics:)
    @factory = factory
    @topics = topics
  end

  def find(topic_slug)
    @factory.decorate @topics.find_by!(slug: topic_slug)
  end

  def each
    @topics.each do |topic|
      yield @factory.decorate(topic)
    end
  end
end
