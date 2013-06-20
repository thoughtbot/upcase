class SendFollowUpEmailJob < Struct.new(:follow_up_id, :section_id)
  include ErrorReporting

  def self.enqueue(follow_up_id, section_id)
    Delayed::Job.enqueue(new(follow_up_id, section_id))
  end

  def perform
    follow_up = FollowUp.find(follow_up_id)
    section = Section.find(section_id)
    Mailer.follow_up(follow_up, section).deliver
    follow_up.update_attribute(:notified_at, Time.zone.now)
  end
end
