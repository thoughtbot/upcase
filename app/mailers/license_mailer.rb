class LicenseMailer < BaseMailer
  def fulfillment_error(license, username)
    @username = username
    @license = license

    mail(
      to: license.user_email,
      cc: 'learn@thoughtbot.com',
      subject: "Fulfillment issues with #{license.licenseable_name}"
    )
  end
end
