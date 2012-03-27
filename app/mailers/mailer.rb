class Mailer < ActionMailer::Base

  def registration_notification(registration)
    @registration = registration

    mail(:to => 'workshops@thoughtbot.com',
         :subject => "New registration notification",
         :from => Clearance.configuration.mailer_sender)
  end

  def invoice(registration)
    @registration = registration

    mail(:to => registration.billing_email,
         :subject => "Your invoice for #{registration.section.course_name}",
         :from => Clearance.configuration.mailer_sender)
  end

  def registration_confirmation(registration)
    @registration = registration

    mail(:to => registration.email,
         :subject => "You're registered for #{registration.section.course_name}",
         :from => Clearance.configuration.mailer_sender)
  end

  def purchase_receipt(purchase)
    @purchase = purchase

    mail(:to => purchase.email,
         :subject => "Your receipt for #{purchase.product.name}",
         :from => Clearance.configuration.mailer_sender)
  end
end
