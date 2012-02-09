class FollowUp < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  scope :have_not_notified, where(:notified_at => nil)

  def notify(section)
    Mailer.follow_up(self, section).deliver
    self.notified_at = Time.now
    self.save
  end
end
