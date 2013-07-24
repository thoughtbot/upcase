class Mailer < BaseMailer
  def purchase_receipt(purchase)
    @purchase = purchase

    mail(
      to: @purchase.email,
      subject: "Your receipt for #{@purchase.purchaseable_name}",
      from: Clearance.configuration.mailer_sender
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

  def byte_notification(email, byte)
    @byte = byte

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] New Byte: #{byte.title}"
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
