class UserMailer < ActionMailer::Base
  def set_password user
    @user = user
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    I18n.t(:change_password,
                      :scope   => [:clearance, :models, :clearance_mailer],
                      :default => "Change your password")
  end
end
