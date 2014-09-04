class Dashboard
  LIMIT = 3

  def shows
    Catalog.new.shows
  end

  def topics
    topics = TopicsWithResources.new(
      topics: Topic.dashboard,
      factory: TopicWithResourcesFactory.new(catalog: Catalog.new)
    )
    topics.to_a.sort_by(&:count).reverse
  end
end
