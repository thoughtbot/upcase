class LicenseMailerPreview < ActionMailer::Preview
  def fullfillment_error
    user = User.new(name: 'John Doe')
    repository = Repository.first

    LicenseMailer.fulfillment_error(repository, user)
  end
end
