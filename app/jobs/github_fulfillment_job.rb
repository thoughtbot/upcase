class GithubFulfillmentJob < Struct.new(:repository_id, :user_id)
  include ErrorReporting

  PREVIEW_MEDIA_TYPE = "application/vnd.github.moondragon+json".freeze
  READ_ONLY_PERMISSION = "pull".freeze

  def self.enqueue(repository_id, user_id)
    Delayed::Job.enqueue(new(repository_id, user_id))
  end

  def perform
    add_on_github
  rescue Octokit::NotFound, Net::HTTPBadResponse
    email_user
    raise
  end

  private

  def add_on_github
    if user.github_username?
      # TODO remove accept once GitHub removes preview mode.
      github_client.add_collaborator(
        repository.github_repository,
        user.github_username,
        accept: PREVIEW_MEDIA_TYPE,
        permission: READ_ONLY_PERMISSION
      )
    end
  end

  def email_user
    LicenseMailer.fulfillment_error(repository, user).deliver_now
  end

  def repository
    Product.find(repository_id)
  end

  def user
    User.find(user_id)
  end

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
