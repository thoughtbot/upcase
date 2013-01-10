class SendRegistrationEmailsJob < Struct.new(:purchase_id)
  include ErrorReporting

  def self.enqueue(purchase_id)
    Delayed::Job.enqueue(new(purchase_id))
  end

  def perform
    purchase = Purchase.find(purchase_id)
    Mailer.registration_notification(purchase).deliver
    Mailer.registration_confirmation(purchase).deliver
  end
end
