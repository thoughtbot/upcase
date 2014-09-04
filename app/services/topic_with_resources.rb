# Decorates a Topic to allow attaching a list of related resources, such as
# exercises and workshops.
class TopicWithResources < SimpleDelegator
  def initialize(topic, resources:)
    super(topic)
    @resources = resources
  end

  def dashboard_resources
    resources.take(Dashboard::LIMIT)
  end

  def resources
    @resources.sort_by(&:created_at).reverse
  end

  def count
    @resources.count
  end
end
