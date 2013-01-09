class FollowUp < ActiveRecord::Base
  belongs_to :course
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, presence: true, format: { with: EMAIL_FORMAT }, on: :create

  scope :have_not_notified, where(notified_at: nil)

  def notify(section)
    Mailer.follow_up(self, section).deliver
    self.notified_at = Time.now
    self.save
  end
end
