class UserMailer < ActionMailer::Base
  def set_password user
    @user = user
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    "Welcome to Thoughbot Workshops"
  end
end
