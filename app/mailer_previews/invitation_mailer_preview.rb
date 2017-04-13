class InvitationMailerPreview < ActionMailer::Preview
  def invitation
    user = User.first
    team = Team.first

    invitation_id = Invitation.first_or_create(
      email: 'user@example.com',
      sender_id: user.id,
      team_id: team.id,
    )

    InvitationMailer.invitation(invitation_id)
  end
end
