require "rails_helper"

RSpec.describe InvitationMailer do
  describe "#invitation" do
    it "delivers an invitation email" do
      invitation = build_stubbed(:invitation)
      allow(Invitation).to receive(:find).with(invitation.id)
        .and_return(invitation)

      email = InvitationMailer.invitation(invitation.id)

      expect(email).to deliver_to(invitation.email)
      expect(email).to deliver_from(Clearance.configuration.mailer_sender)
      expect(email).to have_subject("Invitation")
      expect(email).to have_body_text(new_invitation_acceptance_url(invitation))
    end
  end
end
