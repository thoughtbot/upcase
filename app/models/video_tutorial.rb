class VideoTutorial < Product
  validates :description, :tagline, presence: true

  def teachers
    Teacher.joins(:video).merge(videos).to_a.uniq(&:user_id)
  end

  def collection?
    published_videos.count > 1
  end

  def included_in_plan?(plan)
    plan.has_feature?(:video_tutorials)
  end
end
