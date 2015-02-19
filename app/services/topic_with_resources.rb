# Decorates a Topic to allow attaching a list of related resources, such as
# exercises and video tutorials.
class TopicWithResources < SimpleDelegator
  def initialize(topic, resources:)
    super(topic)
    @resources = resources
  end

  def resources
    @resources.sort_by(&:created_at).reverse
  end

  def count
    @resources.count
  end
end
