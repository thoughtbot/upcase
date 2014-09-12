class DowngradeMailer < BaseMailer
  def notify_mentor(mentor_id:, mentee_id:)
    @mentor = User.find mentor_id
    @mentee = User.find mentee_id

    mail(
      to: @mentor.email,
      subject: "#{@mentee.name} downgraded his/her subscription"
    )
  end
end
