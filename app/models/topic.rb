class Topic < ActiveRecord::Base
  # Associations
  has_many :classifications
  with_options(through: :classifications, source: :classifiable) do |options|
    options.has_many :exercises, source_type: 'Exercise'
    options.has_many :products, source_type: 'Product'
    options.has_many :topics, source_type: 'Topic'
    options.has_many :videos, source_type: 'Video'
    options.has_many :video_tutorials, source_type: 'VideoTutorial'
  end
  has_one :trail

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_slug, on: :create

  def self.top
    featured.order("count DESC").limit 20
  end

  def self.dashboard
    where(dashboard: true).order("count DESC")
  end

  def self.featured
    where(featured: true)
  end

  def self.meta_keywords
    pluck(:name).join(", ")
  end

  def to_param
    slug
  end

  def related
    @related ||= Related.new(self)
  end

  private

  def generate_slug
    if name
      self.slug = CGI::escape(name.strip).downcase
    end
  end
end
