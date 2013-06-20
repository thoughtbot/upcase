class Byte < ActiveRecord::Base
  attr_protected :body_html

  has_many :classifications, as: :classifiable
  has_many :products, through: :topics, uniq: true
  has_many :topics, through: :classifications
  has_many :workshops, through: :topics, uniq: true

  validates :body, presence: true
  validates :body_html, presence: true
  validates :published_on, presence: true
  validates :title, presence: true

  def self.ordered
    order('published_on desc')
  end

  def self.published
    where('published_on <= ?', Time.zone.today).where(draft: false)
  end

  def self.published_today
    published.where(published_on: Time.zone.today)
  end

  def published?
    published_on <= Time.zone.today && !draft?
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def body=(markdown)
    self[:body] = markdown
    if markdown.present?
      self.body_html = BlueCloth.new(markdown).to_html
    end
  end

  def keywords
    topics.map(&:name).join(',')
  end

  def related
    @related ||= Related.new(self)
  end
end
