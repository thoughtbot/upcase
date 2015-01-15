class LandingPage
  def community_size
    User.subscriber_count
  end

  def topics
    Topic.explorable
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
