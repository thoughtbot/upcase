class WeeklyIterationRecommender
  def initialize(user:, sorted_recommendable_videos:)
    @user = user
    @sorted_recommendable_videos = sorted_recommendable_videos
  end

  def recommend
    suggestor.
      next_up.
      present do |video|
        create_recommendation(video)
        enqueue_email_for(video)
      end.
      blank { log_no_further_recommendations(user) }
  end

  private

  attr_reader :user, :sorted_recommendable_videos

  def create_recommendation(video)
    ContentRecommendation.create!(
      user: user,
      recommendable: video,
    )
  end

  def enqueue_email_for(video)
    WeeklyIterationMailerJob.perform_later(user.id, video.id)
  end

  def suggestor
    ContentSuggestor.new(
      user: user,
      recommendables: sorted_recommendable_videos,
      recommended: previously_recommended,
    )
  end

  def previously_recommended
    ContentRecommendation.
      where(user: user).
      map(&:recommendable)
  end

  def log_no_further_recommendations(user)
    Rails.logger.warn(
      "No further recommendable videos for user: #{user.id} <#{user.email}>",
    )
  end
end
