class Article < ActiveRecord::Base
  attr_protected :body_html

  # Associations
  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications
  has_many :products, through: :topics, uniq: true
  has_many :workshops, through: :topics, uniq: true
  # Validations
  validates :published_on, presence: true
  validates :body_html, presence: true
  validates :title, presence: true

  def self.by_published
    order("published_on desc")
  end

  def self.top
    by_published.limit(10)
  end

  def self.local
    where("external_url IS NULL OR external_url = ''")
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def body=(markdown)
    if markdown.present?
      self.body_html = BlueCloth.new(markdown).to_html
    end
  end

  def keywords
    topics.map(&:name).join(',')
  end

  def local?
    external_url.blank?
  end
end
