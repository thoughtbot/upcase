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
end
