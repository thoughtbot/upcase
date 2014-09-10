require "rails_helper"

describe LicenseMailer do
  describe '.fulfillment_error' do
    it 'sets the correct recipients' do
      license = build_stubbed(:license)
      mailer = LicenseMailer.fulfillment_error(license, github_username)

      expect(mailer).to deliver_to(license.user_email)
      expect(mailer).to cc_to(ENV["SUPPORT_EMAIL"])
      expect(mailer).to reply_to(ENV["SUPPORT_EMAIL"])
    end

    it 'sets the correct subject' do
      license = build_stubbed(:license)
      mailer = LicenseMailer.fulfillment_error(license, github_username)

      expect(mailer).to have_subject(
        "Fulfillment issues with #{license.licenseable_name}")
    end

    it 'sets the username in the message body' do
      mailer = LicenseMailer.fulfillment_error(build_stubbed(:license), github_username)

      expect(mailer).to have_body_text(/#{github_username}/)
    end

    def github_username
      'github_username'
    end
  end
end
