require 'mp3info'
require 'open-uri'

class Episode < ActiveRecord::Base
  belongs_to :show
  has_many :classifications, as: :classifiable
  has_many :products, through: :topics, uniq: true
  has_many :topics, through: :classifications
  has_many :workshops, through: :topics, uniq: true

  validates :description, presence: true
  validates :number, presence: true
  validates :published_on, presence: true
  validates :show, presence: true
  validates :title, presence: true

  before_validation :assign_next_number, on: :create
  after_save :enqueue_remote_fetch

  has_attached_file :mp3, {
    s3_permissions: :public_read,
    styles: {
      id3: ''
    },
    processors: [:id3]
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  process_in_background :mp3
  attr_accessor :new_mp3_url

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
    if show
      show.episodes.maximum(:number) || 0
    else
      0
    end
  end

  def enqueue_remote_fetch
    if new_mp3_url.present?
      EpisodeMp3FetchJob.enqueue(self.id, new_mp3_url)
    end
  end
end
