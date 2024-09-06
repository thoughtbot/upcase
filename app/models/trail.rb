class Trail < ApplicationRecord
  extend FriendlyId

  include PgSearch::Model

  DEFAULT_IMAGE_URL =
    "https://images.thoughtbot.com/upcase/trail-title-cards/default.png".freeze

  multisearchable against: %i[name description], if: :published?

  validates :name, :description, presence: true

  has_many :classifications, as: :classifiable, dependent: :destroy
  has_many :repositories, dependent: :destroy
  has_many :statuses, as: :completeable, dependent: :destroy
  has_many :topics, through: :classifications
  has_many :users, through: :statuses
  has_many \
    :steps,
    -> { order "steps.position ASC" },
    dependent: :destroy,
    inverse_of: :trail
  has_many :exercises,
    through: :steps,
    source: :completeable,
    source_type: "Exercise"
  has_many :videos, through: :steps, source: :completeable, source_type: "Video"

  friendly_id :name, use: %i[slugged finders]

  def self.published
    where(published: true)
  end

  def self.completed_for(user)
    TrailWithProgressQuery.new(all, user: user).select(&:complete?)
  end

  def to_s
    name
  end

  # Override setters so it preserves the order
  def step_ids=(new_step_ids)
    super
    new_step_ids = new_step_ids.reject(&:blank?).map(&:to_i)

    new_step_ids.each_with_index do |step_id, index|
      steps.where(id: step_id).update_all(position: index + 1)
    end
  end

  def title_card_image
    super.presence || DEFAULT_IMAGE_URL
  end

  def completeables
    steps.map(&:completeable)
  end

  def update_state_for(user)
    TrailWithProgress.new(
      self,
      user: user,
      status_finder: StatusFinder.new(user: user)
    ).update_status
  end

  def self.most_recent_published
    order(created_at: :desc).published
  end

  def teachers
    Teacher.joins(:video).merge(videos).to_a.uniq(&:user_id)
  end

  def topic_name
    topic.name
  end

  def first_completeable
    first_step.completeable
  end

  def time_to_complete
    videos.sum(:length_in_minutes) + exercise_time
  end

  private

  def first_step
    if steps.loaded?
      steps.min_by(&:position)
    else
      steps.first
    end
  end

  def exercise_time
    exercises.count * Exercise::AVERAGE_COMPLETION_TIME_IN_MINUTES
  end
end
