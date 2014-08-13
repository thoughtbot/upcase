require "rails_helper"

describe InvitationMailer do
  describe '#invitation' do
    it 'delivers an invitation email' do
      invitation = build_stubbed(:invitation)
      Invitation.stubs(:find).with(invitation.id).returns(invitation)

      email = InvitationMailer.invitation(invitation.id)

      expect(email).to deliver_to(invitation.email)
      expect(email).to deliver_from(Clearance.configuration.mailer_sender)
      expect(email).to have_subject('Invitation')
      expect(email).to have_body_text(new_invitation_acceptance_url(invitation))
    end
  end
end
