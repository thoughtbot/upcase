class Topic < ActiveRecord::Base
  # Attributes
  attr_accessible :trail_map, :featured, :keywords, :name, :summary

  # Associations
  has_many :articles, through: :classifications, source: :classifiable,
    source_type: 'Article'
  has_many :classifications
  has_many :courses, through: :classifications, source: :classifiable,
    source_type: 'Course'
  has_many :products, through: :classifications, source: :classifiable,
    source_type: 'Product'

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_slug

  # Serialization
  serialize :trail_map, Hash

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

  def to_param
    slug
  end

  def import_trail_map
    begin
      http = Curl.get(github_url)
      raw_trail_map = http.body_str
      self.trail_map = JSON.parse(raw_trail_map)
      self.summary = trail_map['description']
      save!
    rescue JSON::ParserError => e
      Airbrake.notify(e)
    end
  end

  private

  def generate_slug
    if name
      self.slug = CGI::escape(name.strip).downcase
    end
  end

  def github_url
    "https://raw.github.com/thoughtbot/trail-map/json/trails/#{slug.parameterize}.json"
  end
end
