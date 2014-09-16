class VideoTutorial < Product
  has_many :questions, -> { order 'created_at ASC' }, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :users, through: :teachers

  # Nested Attributes
  accepts_nested_attributes_for :questions, reject_if: :all_blank

  # Validations
  validates :description, presence: true
  validates :length_in_days, presence: true
  validates :tagline, presence: true

  def thumbnail_path
    "video_tutorial_thumbs/#{name.parameterize}.png"
  end

  def starts_on(license_date = nil)
    license_date || Time.zone.today
  end

  def ends_on(license_date = nil)
    starts_on(license_date) + length_in_days
  end

  def collection?
    true
  end

  def included_in_plan?(plan)
    plan.has_feature?(:video_tutorials)
  end
end
