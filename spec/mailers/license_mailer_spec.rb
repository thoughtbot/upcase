require "rails_helper"

describe LicenseMailer do
  describe "#fulfillment_error" do
    it "notifies the user that fulfillment failed" do
      repository = build_stubbed(:repository)
      user = build_stubbed(:user)

      mailer = LicenseMailer.fulfillment_error(repository, user)

      expect(mailer).to deliver_to(user.email)
      expect(mailer).to cc_to(ENV["SUPPORT_EMAIL"])
      expect(mailer).to reply_to(ENV["SUPPORT_EMAIL"])
      expect(mailer).to have_body_text(/#{user.github_username}/)
      expect(mailer).to have_subject(
        "Fulfillment issues with #{repository.name}"
      )
    end
  end
end
