class Topic < ActiveRecord::Base
  # Attributes
  attr_accessible :body_html, :featured, :keywords, :name, :summary

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

  def self.top
    where(featured: true).order('count DESC').limit 20
  end

  def to_param
    slug
  end

  private

  def generate_slug
    if name
      self.slug = CGI::escape(name.strip).downcase
    end
  end
end
