class VideoTutorial < Product
  has_many :teachers, dependent: :destroy
  has_many :users, through: :teachers

  # Validations
  validates :description, presence: true
  validates :length_in_days, presence: true
  validates :tagline, presence: true

  def starts_on(license_date = nil)
    license_date || Time.zone.today
  end

  def ends_on(license_date = nil)
    starts_on(license_date) + length_in_days
  end

  def collection?
    published_videos.count > 1
  end

  def included_in_plan?(plan)
    plan.has_feature?(:video_tutorials)
  end
end
