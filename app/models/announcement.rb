class Announcement < ActiveRecord::Base
  # Attributes
  attr_accessible :announceable_id, :announceable_type, :ends_at, :message

  # Associations
  belongs_to :announceable, polymorphic: true

  # Validations
  validates :announceable_id, presence: true
  validates :announceable_type, presence: true
  validates :ends_at, presence: true
  validates :message, presence: true

  def self.current
    where('ends_at > ?', Time.now).order('ends_at ASC').first
  end
end
