class Mailer < ActionMailer::Base
  default :from => Clearance.configuration.mailer_sender

  def registration_notification(registration)
    @registration = registration

    mail(:to => 'workshops@thoughtbot.com',
         :subject => "New registration notification")
  end

  def invoice(registration)
    @registration = registration

    mail(:to => registration.billing_email,
         :subject => "Your invoice for #{registration.section.course_name}")
  end

  def registration_confirmation(registration)
    @registration = registration

    mail(:to => registration.email,
         :subject => "You're registered for #{registration.section.course_name}")
  end
end
