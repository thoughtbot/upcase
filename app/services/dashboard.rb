class Dashboard
  LIMIT = 3

  def shows
    Catalog.new.shows
  end

  def topics
    topics = TopicsWithResources.new(
      topics: Topic.dashboard,
      factory: TopicWithResourcesFactory.new(catalog: Catalog.new, limit: LIMIT)
    )
    topics.to_a.sort_by(&:count).reverse
  end

  def trails
    Trail.most_recent
  end
end
