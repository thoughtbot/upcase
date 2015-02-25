class Practice
  def initialize(user)
    @user = user
  end

  def has_completed_trails?
    completed_trails.any?
  end

  def just_finished_trails
    trails.select(&:just_finished?)
  end

  def incomplete_trails
    trails.select(&:incomplete?)
  end

  private

  attr_reader :user

  def trails
    Trail.
      most_recent_published.
      map { |trail| TrailWithProgress.new(trail, user: user) }
  end

  def completed_trails
    trails.select(&:complete?)
  end
end
