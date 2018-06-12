class Video < ApplicationRecord
  extend FriendlyId

  include PgSearch
  multisearchable against: [:name, :summary, :notes], if: :search_visible?

  belongs_to :watchable, polymorphic: true
  has_many :classifications, as: :classifiable
  has_many :markers, dependent: :destroy
  has_many :statuses, as: :completeable, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :topics, through: :classifications
  has_many :users, through: :teachers
  has_one :step, as: :completeable, dependent: :destroy
  has_one :trail, through: :step

  validates :published_on, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :wistia_id, presence: true

  delegate :name, to: :watchable, prefix: true
  delegate :download_url, to: :clip

  friendly_id :name, use: [:slugged, :finders]

  def self.ordered
    order('position asc')
  end

  def self.published
    where('published_on <= ?', Time.zone.today)
  end

  def self.recently_published_first
    order('published_on desc')
  end

  def clip
    @video ||= Clip.new(wistia_id)
  end

  def preview
    if preview_wistia_id.present?
      Clip.new(preview_wistia_id)
    else
      VideoThumbnail.new(clip)
    end
  end

  def has_notes?
    notes.present?
  end

  def summary_or_notes
    summary.presence || notes
  end

  def watchable
    super || step.try(:trail)
  end

  def to_param
    slug
  end

  def part_of_trail?
    trail.present?
  end

  def search_visible?
    if part_of_trail?
      trail.published?
    else
      true
    end
  end

  def state_for(user)
    statuses.most_recent_for_user(user).state
  end

  def published?
    if part_of_trail?
      trail.published?
    else
      published_on <= Date.current
    end
  end

  def update_duration(duration = nil)
    if duration.present?
      update(length_in_minutes: duration)
    else
      VideoDurationUpdater.update_duration(self)
    end
  end
end
