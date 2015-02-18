class Explore
  LIMIT = 3

  def initialize(user)
    @user = user
  end

  def show
    Show.the_weekly_iteration || NullShow.new
  end

  def latest_video_tutorial
    VideoTutorial.active.order(:created_at).last
  end

  def topics
    topics = TopicsWithResources.new(
      topics: Topic.explorable,
      factory: TopicWithResourcesFactory.new(
        catalog: Catalog.new(user: @user),
        limit: LIMIT
      )
    )
    topics.to_a.sort_by(&:count).reverse
  end

  def trails
    Trail.most_recent_published
  end
end
