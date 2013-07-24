class WorkshopMailer < BaseMailer
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
end
