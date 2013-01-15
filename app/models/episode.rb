class Episode < ActiveRecord::Base
  attr_accessible :title, :duration, :file, :description, :published_on, :notes,
    :old_url, :file_size, :topic_ids

  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications
  has_many :products, through: :topics, uniq: true

  validates :title, presence: true
  validates :duration, presence: true
  validates :file, presence: true
  validates :file_size, presence: true
  validates :description, presence: true
  validates :published_on, presence: true

  def self.published
    where("published_on <= ?", Date.today).order('published_on desc')
  end

  def full_title
    "Episode #{id}: #{title}"
  end

  def rss_pub_date
    published_on.to_s(:rfc822)
  end

  def increment_downloads
    increment!(:downloads_count)
  end
end
