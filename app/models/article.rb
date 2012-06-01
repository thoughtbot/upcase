class Article < ActiveRecord::Base
  # Associations
  belongs_to :author
  has_and_belongs_to_many :topics, after_add: :update_topic_count, after_remove: :update_topic_count

  # Validations
  validates :published_on, presence: true
  validates :body_html, presence: true
  validates :title, presence: true
  validates :tumblr_url, presence: true

  attr_accessible :title, :body_html, :tumblr_url, :author_id, :published_on, :topic_ids, as: :admin

  def update_topic_count topic
    topic.count = topic.articles.count
    topic.save
  end

end
