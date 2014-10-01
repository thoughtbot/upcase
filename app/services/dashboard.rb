class Dashboard
  LIMIT = 3

  def initialize(user)
    @user = user
  end

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
    Trail.most_recent.map do |trail|
      TrailWithProgress.new(trail, user: @user)
    end
  end
end
