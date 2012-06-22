class Topic < ActiveRecord::Base
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

  attr_accessible :name, :body_html, :keywords, :slug, :summary, :article_ids, as: :admin

  def to_param
    slug
  end

  def name_with_count
    "#{name} (#{count})"
  end
  private

  def generate_slug
    if name
      self.slug = name.parameterize
    end
  end
end
