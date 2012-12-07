class FollowUp < ActiveRecord::Base
  # Attributes
  attr_accessible :email

  # Associations
  belongs_to :course

  # Validations
  validates_presence_of :email
  validates_email_format_of :email

  # Scopes
  scope :have_not_notified, where(notified_at: nil)

  def notify(section)
    Mailer.follow_up(self, section).deliver
    self.notified_at = Time.now
    self.save
  end
end
