class Topic < ActiveRecord::Base
  extend FriendlyId

  has_many :classifications, dependent: :destroy

  with_options(through: :classifications, source: :classifiable) do |options|
    options.has_many :products, source_type: 'Product'
    options.has_many :topics, source_type: 'Topic'
    options.has_many :videos, source_type: 'Video'
  end

  has_many :trails

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :name, use: [:slugged, :finders]

  def self.meta_keywords
    pluck(:name).join(", ")
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

  def weekly_iteration_videos
    videos.where(watchable: Show.the_weekly_iteration)
  end
end
