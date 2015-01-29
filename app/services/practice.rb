class Practice
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def has_completed_trails?
    completed_trails.any?
  end

  def completed_trails
    trails.select(&:complete?)
  end

  def active_trails
    trails.select(&:active?)
  end

  private

  def trails
    Trail.
      most_recent_published.
      map { |trail| TrailWithProgress.new(trail, user: user) }
  end
end
