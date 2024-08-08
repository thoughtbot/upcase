class Topic < ApplicationRecord
  extend FriendlyId

  has_many :classifications, dependent: :destroy

  with_options(through: :classifications, source: :classifiable) do
    has_many :products, source_type: "Product"
    has_many :topics, source_type: "Topic"
    has_many :videos, source_type: "Video"
    has_many :trails, source_type: "Trail"
  end

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  friendly_id :name, use: [:slugged, :finders]

  def self.explorable
    where(explorable: true)
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
