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

  def video_notification(email, video)
    @video = video

    mail(
      to: email,
      subject: "[Learn] #{video.watchable_name}: #{video.title}"
    )
  end

  def office_hours_reminder(section, email)
    @section = section

    mail(
      to: email,
      subject: "[Learn] #{section.name}: Office Hours"
    )
  end

  def workshop_survey(section, email)
    @section = section

    mail(
      to: email,
      subject: "[Learn] #{section.name}: Please tell us how we did"
    )
  end
end
