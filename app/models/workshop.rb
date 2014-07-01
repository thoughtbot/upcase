class Workshop < ActiveRecord::Base
  # Associations
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :classifications, as: :classifiable, dependent: :destroy
  has_many :downloads, as: :purchaseable
  has_many :purchases, as: :purchaseable, dependent: :restrict_with_exception
  has_many :questions, -> { order 'created_at ASC' }, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :topics, through: :classifications
  has_many :users, through: :teachers
  has_many :videos, as: :watchable

  # Nested Attributes
  accepts_nested_attributes_for :questions, reject_if: :all_blank

  # Validations
  validates :description, presence: true
  validates :length_in_days, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

  # Plugins
  acts_as_list

  def self.by_position
    order 'workshops.position ASC'
  end

  def self.only_active
    where active: true
  end

  def self.promoted
    where promoted: true
  end

  def announcement
    @announcement ||= announcements.current
  end

  def questions_with_blank
    questions + [questions.new]
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def purchase_for(user)
    purchases.paid.where(user_id: user).first
  end

  def title
    "#{name}: a workshop from thoughtbot"
  end

  def meta_keywords
    topics.meta_keywords
  end

  def offering_type
    'workshop'
  end

  def tagline
    short_description
  end

  def fulfilled_with_github?
    github_team.present?
  end

  def thumbnail_path
    "workshop_thumbs/#{name.parameterize}.png"
  end

  def subscription?
    false
  end

  def fulfill(purchase, user)
    GithubFulfillment.new(purchase).fulfill
  end

  def starts_on(purchase_date = nil)
    purchase_date || Time.zone.today
  end

  def ends_on(purchase_date = nil)
    starts_on(purchase_date) + length_in_days
  end

  def collection?
    true
  end

  def to_aside_partial
    'workshops/aside'
  end

  def published_videos
    videos.published
  end

  def included_in_plan?(plan)
    plan.has_feature?(:workshops)
  end
end
