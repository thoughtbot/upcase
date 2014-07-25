require 'spec_helper'

describe LicenseMailer do
  describe '.fulfillment_error' do
    it 'sets the correct recipients' do
      license = stubbed_license
      mailer = LicenseMailer.fulfillment_error(license, github_username)

      expect(mailer).to deliver_to(license.user_email)
      expect(mailer).to cc_to('learn@thoughtbot.com')
      expect(mailer).to reply_to('learn@thoughtbot.com')
    end

    it 'sets the correct subject' do
      license = stubbed_license
      mailer = LicenseMailer.fulfillment_error(license, github_username)

      expect(mailer).to have_subject(
        "Fulfillment issues with #{license.licenseable_name}")
    end

    it 'sets the username in the message body' do
      mailer = LicenseMailer.fulfillment_error(stubbed_license, github_username)

      expect(mailer).to have_body_text(/#{github_username}/)
    end

    def github_username
      'github_username'
    end

    def stubbed_license
      stub(
        licenseable_name: 'Backbone.js on Rails',
        name: 'Benny Burns',
        user_email: 'benny@theburns.org'
      )
    end
  end
end
