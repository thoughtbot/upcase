class VideoListing
  include Enumerable

  UNSTARTED = Unstarted.new

  def initialize(videos, user)
    @videos = videos
    @user = user
  end

  def each(&block)
    videos_with_status.each(&block)
  end

  delegate(
    :current_page,
    :total_pages,
    :limit_value,
    :model_name,
    :total_count,
    to: :videos,
  )

  private

  attr_reader :user, :videos

  def videos_with_status
    @videos_with_status ||= videos_with_associations.map do |video|
      VideoWithStatus.new(video, video_status(video))
    end
  end

  def videos_with_associations
    videos.includes(:topics, :users)
  end

  def video_status(video)
    if user.present?
      video_statuses.fetch(video.id, [UNSTARTED]).first
    else
      UNSTARTED
    end
  end

  def video_statuses
    @video_statuses ||= Status.
      select("DISTINCT ON (completeable_type, completeable_id, user_id) *").
      where(completeable_type: "Video", completeable_id: videos.map(&:id)).
      where(user: user).
      order(:completeable_type, :completeable_id, :user_id, updated_at: :desc).
      group_by(&:completeable_id)
  end
end
