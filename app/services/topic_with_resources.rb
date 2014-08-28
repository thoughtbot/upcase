# Decorates a Topic to allow attaching a list of related resources, such as
# exercises and workshops.
class TopicWithResources < SimpleDelegator
  DASHBOARD_LIMIT = 3

  def initialize(topic, resources:)
    super(topic)
    @resources = resources
  end

  def dashboard_resources
    resources.take(DASHBOARD_LIMIT)
  end

  def resources
    @resources.sort_by(&:created_at).reverse
  end

  def count
    @resources.count
  end
end
