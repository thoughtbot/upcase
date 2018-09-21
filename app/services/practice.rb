class Practice
  def initialize(trails:)
    @trails = trails
  end

  def has_completed_trails?
    completed_trails.any?
  end

  def just_finished_trails
    trails.select(&:just_finished?)
  end

  def promoted_unstarted_trails
    unstarted_trails.select(&:promoted?)
  end

  def unpromoted_unstarted_trails
    unstarted_trails.reject(&:promoted?)
  end

  def in_progress_trails
    trails.select(&:in_progress?).sort_by(&:started_on).reverse
  end

  private

  attr_reader :trails

  def unstarted_trails
    trails.select(&:unstarted?)
  end

  def completed_trails
    trails.select(&:complete?)
  end
end
