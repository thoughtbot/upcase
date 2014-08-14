class InvitationMailer < BaseMailer
  def invitation(invitation_id)
    @invitation = Invitation.find(invitation_id)

    mail(
      to: @invitation.email,
      subject: "Invitation"
    )
  end
end
