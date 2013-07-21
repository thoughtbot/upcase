require 'mp3info'
require 'open-uri'

class Episode < ActiveRecord::Base
  attr_accessible :title, :duration, :description, :published_on, :notes,
    :old_url, :file_size, :topic_ids, :mp3

  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications
  has_many :products, through: :topics, uniq: true
  has_many :workshops, through: :topics, uniq: true

  validates :title, presence: true
  validates :description, presence: true
  validates :published_on, presence: true
  validates :number, presence: true

  before_validation :assign_next_number, on: :create

  has_attached_file :mp3, {
    s3_permissions: :public_read,
    styles: {
      id3: ''
    },
    processors: [:id3]
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def self.published
    where('published_on <= ?', Time.zone.today).order('published_on desc')
  end

  def full_title
    "Episode #{number}: #{title}"
  end

  def rss_pub_date
    published_on.to_s(:rfc822)
  end

  def increment_downloads
    increment!(:downloads_count)
  end

  def related
    @related ||= Related.new(self)
  end

  def to_param
    number
  end

  private

  def assign_next_number
    self.number ||= maximum_number + 1
  end

  def maximum_number
    Episode.maximum(:number) || 0
  end
end
