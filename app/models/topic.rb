class Topic < ActiveRecord::Base
  extend FriendlyId

  has_many :classifications, dependent: :destroy

  with_options(through: :classifications, source: :classifiable) do |options|
    options.has_many :exercises, source_type: 'Exercise'
    options.has_many :products, source_type: 'Product'
    options.has_many :topics, source_type: 'Topic'
    options.has_many :videos, source_type: 'Video'
  end

  has_many :trails

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :name, use: [:slugged, :finders]

  def self.explorable
    where(explorable: true)
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
end
