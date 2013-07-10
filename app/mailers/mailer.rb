class Mailer < ActionMailer::Base
  default from: Clearance.configuration.mailer_sender
  add_template_helper PurchasesHelper
  add_template_helper ApplicationHelper

  def welcome_to_prime(user)
    @user = user

    mail to: @user.email, subject: 'Welcome to Prime', from: 'Chad Pytel <chad@thoughtbot.com>'
  end

  def purchase_receipt(purchase)
    @purchase = purchase

    mail(
      to: @purchase.billing_email,
      subject: "Your receipt for #{@purchase.purchaseable_name}",
      from: Clearance.configuration.mailer_sender
    )
  end

  def follow_up(follow_up, section)
    @section = section

    mail(
      to: follow_up.email,
      subject: "The #{@section.workshop.name} workshop has been scheduled"
    )
  end

  def teacher_notification(teacher_id, section_id)
    teacher = Teacher.find(teacher_id)
    @section = Section.find(section_id)

    mail(
      to: teacher.email,
      subject: "You have been scheduled to teach #{@section.workshop.name}"
    )
  end

  def section_reminder(purchase_id, section_id)
    @purchase = Purchase.find(purchase_id)
    @section = Section.find(section_id)

    mail(
      to: @purchase.email,
      subject: "Reminder: #{@purchase.purchaseable_name} is scheduled to start in a week on #{@section.starts_on.to_s(:simple)}. Mark your calendar!"
    )
  end

  def fulfillment_error(purchase, username)
    @username = username
    @purchase = purchase

    mail(
      to: purchase.email,
      cc: 'learn@thoughtbot.com',
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "Fulfillment issues with #{purchase.purchaseable_name}"
    )
  end

  def video_notification(email, video)
    @video = video

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] #{video.watchable_name}: #{video.title}"
    )
  end

  def office_hours_reminder(section, email)
    @section = section

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] #{section.name}: Office Hours"
    )
  end

  def workshop_survey(section, email)
    @section = section

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] #{section.name}: Please tell us how we did"
    )
  end

  def byte_notification(email, byte)
    @byte = byte

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] New Byte: #{byte.title}"
    )
  end

  def unsubscription_survey(user)
    @user = user

    mail(
      to: user.email,
      subject: 'Suggestions for improving Prime'
    )
  end

  def subscription_receipt(email, plan_name, amount, stripe_invoice_id)
    @plan_name = plan_name
    @amount = amount
    @stripe_invoice_id = stripe_invoice_id

    mail(
      to: email,
      subject: "[Learn] Your #{plan_name} receipt and some tips",
      from: Clearance.configuration.mailer_sender
    )
  end
end
