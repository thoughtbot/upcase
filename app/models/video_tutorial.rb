class VideoTutorial < Product
  has_many :teachers, dependent: :destroy
  has_many :users, through: :teachers

  # Validations
  validates :description, presence: true
  validates :tagline, presence: true

  def collection?
    published_videos.count > 1
  end

  def included_in_plan?(plan)
    plan.has_feature?(:video_tutorials)
  end
end
