class Announcement < ActiveRecord::Base
  # Associations
  belongs_to :announceable, polymorphic: true

  # Validations
  validates :announceable_id, presence: true
  validates :announceable_type, presence: true
  validates :ends_at, presence: true
  validates :message, presence: true

  def self.current
    where('ends_at > ?', Time.zone.now).order('ends_at ASC').first
  end
end
