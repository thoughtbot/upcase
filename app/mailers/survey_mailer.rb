class SurveyMailer < BaseMailer
  def workshop_survey(section, email)
    @section = section

    mail(
      to: email,
      from: 'learn@thoughtbot.com',
      reply_to: 'learn@thoughtbot.com',
      subject: "[Learn] #{section.name}: Please tell us how we did"
    )
  end

  def unsubscription_survey(user)
    @user = user

    mail(
      to: user.email,
      subject: 'Suggestions for improving Prime'
    )
  end
end
