# Factory which can decorate a Topic with a list of related resources from a
# Catalog.
class TopicWithResourcesFactory
  RESOURCE_TYPES = %i(exercises products videos workshops)

  def initialize(catalog:, limit: nil)
    @catalog = catalog
    @resources = {}
    @limit = limit
  end

  def decorate(topic)
    TopicWithResources.new(topic,
                           resources: resources(topic),
                           limit: @limit)
  end

  def resources(topic)
    RESOURCE_TYPES.
      map { |resource_type| classified_as(topic, resource_type) }.
      flatten
  end

  def classified_as(topic, resource_type)
    catalog(resource_type).select do |classifiable|
      classifiable.classifications.map(&:topic_id).include?(topic.id)
    end
  end

  def catalog(resource_type)
    @resources[resource_type] ||=
      @catalog.send(resource_type).includes(:classifications)
  end
end
