class Topic < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :articles, after_add: :increment_count, after_remove: :decrement_count
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

  def increment_count article
    self.count = self.articles.count
    self.save
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
