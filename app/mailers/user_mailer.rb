class UserMailer < ActionMailer::Base
  default :from => Clearance.configuration.mailer_sender

  def set_password(user)
    @user = user
    mail(:to      => @user.email,
         :subject => "Welcome to thoughtbot Workshops")
  end

  def follow_up(follow_up, section)
    @section = section
    mail(:to      => follow_up.email,
         :subject => "The #{@section.course.name} workshop has been scheduled")
  end

  def teacher_notification(teacher, section)
    @section = section
    mail(:to      => teacher.email,
         :subject => "You have been scheduled to teach #{@section.course.name}")
  end

  def before_section_reminder(registration, section)
    @section = section
    mail(:to      => registration.billing_email,
         :subject => "Reminder: #{@section.course.name} is scheduled to start in a week on #{@section.starts_on.to_time.to_s(:simple)}. Mark your calendar!")
  end
end
