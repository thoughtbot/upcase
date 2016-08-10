class ContentSuggestor
  def initialize(recommendables:, user:, recommended:)
    @recommendables = recommendables
    @status_finder = StatusFinder.new(user: user)
    @recommended = recommended
  end

  def next_up
    first_unseen_recommendable.wrapped
  end

  private

  attr_reader :recommendables, :recommended, :status_finder

  def unrecommended_recommendables
    recommendables - recommended
  end

  def first_unseen_recommendable
    unrecommended_recommendables.detect do |recommendable|
      status_finder.current_status_for(recommendable).unstarted?
    end
  end
end
