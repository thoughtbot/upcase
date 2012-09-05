class Topic < ActiveRecord::Base
  attr_accessible :body_html, :keywords, :name, :summary, :featured

  # Associations
  has_many :classifications
  has_many :articles, through: :classifications, source: :classifiable, source_type: 'Article'
  has_many :products, through: :classifications, source: :classifiable, source_type: 'Product'
  has_many :courses, through: :classifications, source: :classifiable, source_type: 'Course'
  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_slug

  # scoping
  default_scope order("count desc")

  def self.featured
    where(featured: true)
  end

  def self.top
    featured.order("count desc").limit(20)
  end

  def self.search(text)
    text.downcase!
    text.strip!
    text = escape_if_needed(text)
    topic = where(slug: text).first
    if topic
      [topic]
    else
      where("slug like ?", "#{text}%")
    end
  end

  def to_param
    slug
  end

  private

  def self.escape_if_needed(text)
    escaping_needed?(text) ? CGI::escape(text) : text
  end

  def self.escaping_needed?(text)
    text =~ /\s/
  end

  def generate_slug
    if name
      self.slug = CGI::escape(name.strip).downcase
    end
  end
end
