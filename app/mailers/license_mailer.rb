class LicenseMailer < BaseMailer
  def fulfillment_error(license, username)
    @username = username
    @license = license

    mail(
      to: license.user_email,
      cc: ENV["SUPPORT_EMAIL"],
      subject: "Fulfillment issues with #{license.licenseable_name}"
    )
  end
end
