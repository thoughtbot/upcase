class VideoTutorial < Product
  validates :description, :tagline, presence: true

  def teachers
    Teacher.joins(:video).merge(videos).to_a.uniq(&:user_id)
  end

  def included_in_plan?(plan)
    plan.has_feature?(:trails)
  end
end
