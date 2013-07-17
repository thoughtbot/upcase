class FollowUp < ActiveRecord::Base
  # Attributes
  attr_accessible :email

  # Associations
  belongs_to :workshop

  # Validations
  validates_email_format_of :email, on: :create

  def self.have_not_notified
    where(notified_at: nil)
  end

  def notify(section)
    SendFollowUpEmailJob.enqueue id, section.id
  end
end
