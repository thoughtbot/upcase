require "rails_helper"

describe DowngradeMailer do
  describe '.notify_mentor' do
    it 'sends an email to the mentor' do
      mentee = build_stubbed(:subscriber)
      mentor = build_stubbed(:mentor)
      User.stubs(:find).with(mentee.id).returns(mentee)
      Mentor.stubs(:find).with(mentor.id).returns(mentor)

      mail = DowngradeMailer.
               notify_mentor(mentor_id: mentor.id, mentee_id: mentee.id).
               deliver_now

      expect(mail).to deliver_to(mentor.email)
      expect(mail).to deliver_from(Clearance.configuration.mailer_sender)
      expect(mail).to have_subject(/#{mentee.name} downgraded/)
      expect(mail).to have_body_text(/Hi #{mentor.name}/)
      expect(mail).to have_body_text(/Your mentee #{mentee.name}/)
    end
  end
end
