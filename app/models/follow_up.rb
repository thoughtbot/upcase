class FollowUp < ActiveRecord::Base
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  belongs_to :workshop
  validates :email, presence: true, format: { with: EMAIL_FORMAT }, on: :create

  scope :have_not_notified, where(notified_at: nil)

  def notify(section)
    SendFollowUpEmailJob.enqueue(id, section.id)
  end
end
