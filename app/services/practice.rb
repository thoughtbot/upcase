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

  def unstarted_trails
    trails.select(&:unstarted?)
  end

  def in_progress_trails
    trails.select(&:in_progress?)
  end

  attr_reader :beta_offers

  private

  attr_reader :trails

  def completed_trails
    trails.select(&:complete?)
  end
end
