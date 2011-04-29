class Mailer < ActionMailer::Base

  def registration_notification(registration)
    @registration = registration

    mail(:to => 'workshops@thoughtbot.com',
         :subject => "New registration notification",
         :from => Clearance.configuration.mailer_sender)
  end
end
