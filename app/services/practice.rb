class Practice
  def initialize(user)
    @user = user
  end

  def trails
    Trail.
      most_recent_published.
      map { |trail| TrailWithProgress.new(trail, user: @user) }.
      select(&:active?)
  end

  def has_completed_trails?
    completed_trails.any?
  end

  def completed_trails
    Status.completed.by_user(@user).by_type("Trail").
    map(&:completeable)
  end

  def incompleted_trails
    Status.incompleted.by_user(@user).by_type("Trail").
    map(&:completeable)
  end
end
