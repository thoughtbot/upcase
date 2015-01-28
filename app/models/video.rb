class Video < ActiveRecord::Base
  extend FriendlyId

  belongs_to :watchable, polymorphic: true
  has_many :classifications, as: :classifiable
  has_many :statuses, as: :completeable, dependent: :destroy
  has_many :steps, as: :completeable, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :topics, through: :classifications
  has_many :trails, through: :steps
  has_many :users, through: :teachers

  validates :published_on, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :watchable_id, presence: true
  validates :watchable_type, presence: true
  validates :wistia_id, presence: true

  delegate :included_in_plan?, to: :watchable
  delegate :name, to: :watchable, prefix: true

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

  def notes_html
    BlueCloth.new(notes).to_html
  end

  def to_param
    slug
  end

  def update_trails_state_for(_user)
    # Waiting on story for adding Videos as steps of a trail, does
    # nothing for now.
  end
end
