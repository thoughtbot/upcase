require 'mp3info'
require 'open-uri'

class Episode < ActiveRecord::Base
  attr_accessible :title, :duration, :file, :description, :published_on, :notes,
    :old_url, :file_size, :topic_ids

  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications
  has_many :products, through: :topics, uniq: true
  has_many :workshops, through: :topics, uniq: true

  validates :title, presence: true
  validates :duration, presence: true
  validates :file, presence: true
  validates :file_size, presence: true
  validates :description, presence: true
  validates :published_on, presence: true

  before_validation :extract_info_from_mp3, on: :create

  def self.published
    where('published_on <= ?', Time.zone.today).order('published_on desc')
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

  def related
    @related ||= Related.new(self)
  end

  private

  def extract_info_from_mp3
    if file.present? && title.blank?
      self.file_size = mp3_file.size
      Mp3Info.open(mp3_file) do |mp3|
        extract_tag_info(mp3)
      end
    end
  end

  def mp3_file
    @mp3_file ||= open(file)
  end

  def extract_tag_info(mp3)
    self.title = extract_title(mp3.tag2.TIT2)
    self.description = extract_description(mp3.tag2.TDES)
    self.notes = extract_notes(mp3.tag2.TDES)
    self.published_on = Date.parse(mp3.tag2.TDRL)
    self.duration = mp3.length.to_i
  end

  def extract_title(mp3_title)
    mp3_title.split(':')[1].strip
  end

  def extract_description(mp3_des)
    mp3_des.lines.first.chomp
  end

  def extract_notes(mp3_des)
    mp3_des.split("\n")[1..-1].join("\n")
  end
end
