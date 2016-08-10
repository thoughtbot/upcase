class ContentSuggestor
  def initialize(recommendables:, user:, recommendations:)
    @recommendables = recommendables
    @status_finder = StatusFinder.new(user: user)
    @recommendations = recommendations
  end

  def next_up
    first_unseen_recommendable.wrapped
  end

  private

  attr_reader :recommendables, :recommendations, :status_finder

  def unrecommended_recommendables
    recommendables - recommendations
  end

  def first_unseen_recommendable
    unrecommended_recommendables.detect do |recommendable|
      status_finder.current_status_for(recommendable).unstarted?
    end
  end
end
