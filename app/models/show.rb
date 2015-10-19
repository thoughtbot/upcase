class Show < Product
  THE_WEEKLY_ITERATION = 'The Weekly Iteration'

  def self.accessible_without_subscription?
    false
  end

  def self.the_weekly_iteration
    where(name: THE_WEEKLY_ITERATION).first
  end

  def latest_video
    videos.published.recently_published_first.first
  end
end
