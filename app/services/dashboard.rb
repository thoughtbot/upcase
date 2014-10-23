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
      factory: TopicWithResourcesFactory.new(
        catalog: Catalog.new(user: @user),
        limit: LIMIT
      )
    )
    topics.to_a.sort_by(&:count).reverse
  end

  def trails
    Trail.
      most_recent_published.
      map { |trail| TrailWithProgress.new(trail, user: @user) }.
      select(&:active?)
  end

  def has_completed_trails?
    Status.where(
      completeable_type: "Trail",
      state: "Complete",
      user: @user
    ).exists?
  end
end
