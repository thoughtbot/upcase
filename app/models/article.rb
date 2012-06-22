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

  attr_accessible :title, :body_html, :tumblr_url, :author_id, :published_on, :topic_ids, as: :admin
end
