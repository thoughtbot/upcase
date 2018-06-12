class WeeklyIterationSuggestions < ApplicationJob
  include ErrorReporting

  def initialize(subscribers)
    @subscribers = subscribers
    @sorted_recommendable_videos = RecommendableContent.
      priority_ordered.
      map(&:recommendable)
  end

  def send
    subscribers.each do |subscriber|
      WeeklyIterationRecommender.new(
        user: subscriber,
        sorted_recommendable_videos: sorted_recommendable_videos,
      ).recommend
    end
  end

  private

  attr_reader :subscribers, :sorted_recommendable_videos
end
