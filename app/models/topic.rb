class Topic < ActiveRecord::Base
  # Attributes
  attr_accessible :featured, :keywords, :name, :summary,
    :related_topic_ids

  # Associations
  has_many :articles, through: :classifications, source: :classifiable,
    source_type: 'Article'
  has_many :bytes, through: :classifications, source: :classifiable,
    source_type: 'Byte'
  has_many :classifications
  has_many :workshops, through: :classifications, source: :classifiable,
    source_type: 'Workshop'
  has_many :episodes, through: :classifications, source: :classifiable,
    source_type: 'Episode'
  has_many :products, through: :classifications, source: :classifiable,
    source_type: 'Product'
  has_many :topics, through: :classifications, source: :classifiable,
    source_type: 'Topic'
  has_one :trail

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_slug, on: :create

  def self.top
    featured.order('count DESC').limit 20
  end

  def self.featured
    where(featured: true)
  end

  def self.import_trail_maps
    featured.find_each do |topic|
      topic.import_trail_map
    end
  end

  def self.meta_keywords
    pluck(:name).join(', ')
  end

  def to_param
    slug
  end

  def related
    @related ||= Related.new(self)
  end

  def import_trail_map
    if trail
      trail.import
    end
  end

  private

  def generate_slug
    if name
      self.slug = CGI::escape(name.strip).downcase
    end
  end
end
