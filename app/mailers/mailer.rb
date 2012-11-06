class Mailer < ActionMailer::Base
  default from: Clearance.configuration.mailer_sender

  def registration_notification(registration)
    @registration = registration

    mail(
      to: 'learn@thoughtbot.com',
      subject: "New registration notification"
    )
  end

  def invoice(registration)
    @registration = registration

    mail(
      to: registration.billing_email,
      subject: "Your invoice for #{registration.section.course_name}"
    )
  end

  def registration_confirmation(registration)
    @registration = registration
    @section = registration.section

    mail(
      to: registration.email,
      subject: "You're registered for #{registration.section.course_name}"
    )
  end

  def purchase_receipt(purchase)
    @purchase = purchase

    mail(
      to: purchase.email,
      subject: "Your receipt for #{purchase.product.name}",
      from: Clearance.configuration.mailer_sender
    )
  end

  def set_password(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Welcome to thoughtbot Learn"
    )
  end

  def follow_up(follow_up, section)
    @section = section

    mail(
      to: follow_up.email,
      subject: "The #{@section.course.name} workshop has been scheduled"
    )
  end

  def teacher_notification(teacher, section)
    @section = section

    mail(
      to: teacher.email,
      subject: "You have been scheduled to teach #{@section.course.name}"
    )
  end

  def section_reminder(registration, section)
    @section = section
    @registration = registration

    mail(
      to: registration.email,
      subject: "Reminder: #{section.course.name} is scheduled to start in a week on #{section.starts_on.to_s(:simple)}. Mark your calendar!"
    )
  end

  def fulfillment_error(purchase, username)
    @username = username
    @purchase = purchase

    mail(
      to: purchase.email,
      cc: 'support@thoughtbot.com',
      subject: "Fulfillment issues with #{purchase.product_name}"
    )
  end
end
