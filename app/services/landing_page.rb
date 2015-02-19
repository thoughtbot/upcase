class LandingPage
  def community_size
    User.subscriber_count
  end

  def topics
    topics = TopicsWithResources.new(
      topics: Topic.explorable,
      factory: TopicWithResourcesFactory.new(
        catalog: Catalog.new
      )
    )
    topics.to_a.sort_by(&:count).reverse
  end

  def example_trail
    TrailWithProgress.new(Trail.most_recent_published.first, user: nil)
  end

  def primary_plan
    Plan.popular
  end

  def secondary_plan
    Plan.basic
  end
end
