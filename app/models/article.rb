class Article < ActiveRecord::Base
  # Associations
  belongs_to :author
  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications
  # Validations
  validates :published_on, presence: true
  validates :body_html, presence: true
  validates :title, presence: true
  validates :tumblr_url, presence: true

  def self.by_published
    order("published_on desc")
  end

  def self.top
    by_published.limit(10)
  end
end
