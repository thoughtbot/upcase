class Episode < ActiveRecord::Base
  attr_accessible :title, :duration, :file, :description, :published_on, :notes,
    :old_url, :file_size

  validates_presence_of :title, :duration, :file, :file_size, :description,
    :published_on

  def self.published
    where("published_on <= ?", Date.today).order('published_on desc')
  end

  def full_title
    "Episode #{id}: #{title}"
  end
end
