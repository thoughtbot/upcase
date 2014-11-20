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
    Status.where(
      completeable_type: "Trail",
      state: "Complete",
      user: @user
    ).exists?
  end
end
