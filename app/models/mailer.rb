class Mailer < ActionMailer::Base
  def registration_notification registration
    @registration = registration
    from       Clearance.configuration.mailer_sender
    recipients 'workshops@thoughtbot.com'
    subject    "New registration notification"
  end
end
