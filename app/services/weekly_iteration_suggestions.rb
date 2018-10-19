class WeeklyIterationSuggestions < ApplicationJob
  include ErrorReporting

  def initialize(users)
    @users = users
    @sorted_recommendable_videos = RecommendableContent.
      priority_ordered.
      map(&:recommendable)
  end

  def send
    users.each do |user|
      WeeklyIterationRecommender.new(
        user: user,
        sorted_recommendable_videos: sorted_recommendable_videos,
      ).recommend
    end
  end

  private

  attr_reader :users, :sorted_recommendable_videos
end
