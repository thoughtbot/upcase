class ShowListing < SimpleDelegator
  UNSTARTED = Unstarted.new

  def initialize(show, user)
    super(show)
    @user = user
  end

  def videos_with_status
    @videos_with_status ||= videos.map do |video|
      VideoWithStatus.new(video, video_status(video))
    end
  end

  private

  attr_reader :user

  def videos
    @videos ||= published_videos.includes(:topics).recently_published_first
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
