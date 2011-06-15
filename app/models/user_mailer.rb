class UserMailer < ActionMailer::Base
  def set_password user
    @user = user
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    "Welcome to thoughtbot Workshops"
  end

  def follow_up follow_up, section
    @section = section
    from Clearance.configuration.mailer_sender
    recipients follow_up.email
    subject "The #{@section.course.name} workshop has been scheduled"
  end

  def teacher_notification teacher, section
    @section = section
    from Clearance.configuration.mailer_sender
    recipients teacher.email
    subject "You have been scheduled to teach #{@section.course.name}"
  end
end
