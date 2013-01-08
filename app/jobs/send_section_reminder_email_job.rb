class SendSectionReminderEmailJob < Struct.new(:purchase_id, :section_id)
  include ErrorReporting

  def self.enqueue(purchase_id, section_id)
    Delayed::Job.enqueue(new(purchase_id, section_id))
  end

  def perform
    purchase = Purchase.find(purchase_id)
    section = Section.find(section_id)

    Mailer.section_reminder(purchase, section).deliver
  end
end
