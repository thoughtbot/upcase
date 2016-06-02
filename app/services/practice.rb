class Practice
  def initialize(trails:, beta_offers:)
    @trails = trails
    @beta_offers = beta_offers
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

  attr_reader :beta_offers

  private

  attr_reader :trails

  def unstarted_trails
    trails.select(&:unstarted?)
  end

  def completed_trails
    trails.select(&:complete?)
  end
end
