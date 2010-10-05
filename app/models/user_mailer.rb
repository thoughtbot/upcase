class UserMailer < ActionMailer::Base
  def set_password user
    @user = user
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    "Welcome to Thoughbot Workshops"
  end

  def follow_up follow_up, section
    @section = section
    from Clearance.configuration.mailer_sender
    recipients follow_up.email
    subject "The #{@section.course.name} workshop has been scheduled"
  end
end
