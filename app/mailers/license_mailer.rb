class LicenseMailer < BaseMailer
  def fulfillment_error(repository, user)
    @repository = repository
    @user = user

    mail(
      to: @user.email,
      cc: ENV["SUPPORT_EMAIL"],
      subject: "Fulfillment issues with #{@repository.name}"
    )
  end
end
