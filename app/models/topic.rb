class Topic < ActiveRecord::Base
  extend FriendlyId

  has_many :classifications, dependent: :destroy

  with_options(through: :classifications, source: :classifiable) do |options|
    options.has_many :exercises, source_type: 'Exercise'
    options.has_many :products, source_type: 'Product'
    options.has_many :topics, source_type: 'Topic'
    options.has_many :videos, source_type: 'Video'
    options.has_many :video_tutorials,
                     -> { where(type: "VideoTutorial") },
                     source_type: "Product"
  end

  has_one :legacy_trail
  has_many :trails

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :name, use: [:slugged, :finders]

  def self.top
    featured.order("count DESC").limit 20
  end

  def self.explorable
    where(explorable: true).order("count DESC")
  end

  def self.featured
    where(featured: true)
  end

  def self.meta_keywords
    pluck(:name).join(", ")
  end

  def self.with_colors
    where("color != ''")
  end

  def to_s
    name
  end

  def published_trails
    trails.published
  end

  def to_param
    slug
  end

  def related
    @related ||= Related.new(self)
  end
end
