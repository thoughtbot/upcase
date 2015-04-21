class Explore
  def initialize(user)
    @user = user
  end

  def show
    Show.the_weekly_iteration
  end

  def latest_video_trail
    Trail.
      most_recent_published.
      distinct.
      joins(:steps).where(steps: { completeable_type: "Video" }).
      first
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

  def trails
    Trail.most_recent_published
  end
end
