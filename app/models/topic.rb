class Topic < ActiveRecord::Base
  # Attributes
  attr_accessible :trail_map, :featured, :keywords, :name, :summary,
    :related_topic_ids

  # Associations
  has_many :articles, through: :classifications, source: :classifiable,
    source_type: 'Article'
  has_many :classifications
  has_many :workshops, through: :classifications, source: :classifiable,
    source_type: 'Workshop'
  has_many :episodes, through: :classifications, source: :classifiable,
    source_type: 'Episode'
  has_many :products, through: :classifications, source: :classifiable,
    source_type: 'Product'
  has_many :related_topics, through: :classifications, source: :classifiable,
    source_type: 'Topic'

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_slug, on: :create

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

  def contribute_url
    "https://github.com/thoughtbot/trail-map/blob/master/trails/#{slug.parameterize}.json"
  end

  def to_param
    slug
  end

  def import_trail_map
    http = Curl.get(github_url)
    if http.response_code == 200
      begin
        parse_and_assign_trail_map(http.body_str)
        assign_attributes_from_trail_map
        save!
      rescue JSON::ParserError => e
        Airbrake.notify(e)
      end
    end
  end

  def self.meta_keywords
    pluck(:name).join(', ')
  end

  private

  def generate_slug
    if name
      self.slug = CGI::escape(name.strip).downcase
    end
  end

  def github_url
    "https://raw.github.com/thoughtbot/trail-map/master/trails/#{slug.parameterize}.json"
  end

  def parse_and_assign_trail_map(raw_trail_map)
    self.trail_map = JSON.parse(raw_trail_map)
  end

  def assign_attributes_from_trail_map
    self.summary = trail_map['description']
    self.name = trail_map['name']
    if trail_map['prerequisites'].present?
      trail_map['prerequisites'].each do |related|
        p "#{trail_map['name']}: looking for prerequisites: #{related}"
        prerequisite_topic = Topic.find_by_slug(related)
        unless self.related_topics.include?(prerequisite_topic)
          self.related_topics << prerequisite_topic
        end
      end
    end
  end
end
