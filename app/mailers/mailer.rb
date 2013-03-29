class Mailer < ActionMailer::Base
  default from: Clearance.configuration.mailer_sender
  add_template_helper PurchasesHelper
  add_template_helper ApplicationHelper

  def registration_notification(purchase)
    @comments = purchase.comments
    @student_name = purchase.name
    @workshop_name = purchase.purchaseable_name
    @city = purchase.purchaseable.city
    @running_date_range = purchase.purchaseable.date_range
    @fulfillment_method = purchase.purchaseable.fulfillment_method
    @student_email = purchase.email

    mail(
      to: 'learn@thoughtbot.com',
      subject: "New registration notification"
    )
  end

  def registration_confirmation(purchase)
    @purchase = purchase
    @section = @purchase.purchaseable

    mail(
      to: @purchase.email,
      subject: "You're registered for #{@purchase.purchaseable_name}"
    )
  end

  def welcome_to_prime(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Welcome to Prime"
    )
  end

  def purchase_receipt(purchase)
    @purchase = purchase

    mail(
      to: @purchase.email,
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

  def notification(email, item)
    @item = item

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] #{notification_item_name(item)}: #{item.title}"
    )
  end

  private

  def notification_item_name(item)
    if item.respond_to?(:watchable)
      item.watchable.name
    else
      item.workshop.name
    end
  end
end
