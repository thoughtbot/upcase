class GithubFulfillmentJob < Struct.new(:github_team, :username, :license_id)
  include ErrorReporting

  PREVIEW_MEDIA_TYPE =
    "application/vnd.github.the-wasp-preview+json".freeze

  def self.enqueue(github_team, username, license_id=nil)
    Delayed::Job.enqueue(new(github_team, username, license_id))
  end

  def perform
    add_on_github
  rescue Octokit::NotFound, Net::HTTPBadResponse
    email_user
    raise
  end

  private

  def add_on_github
    if username
      # TODO remove accept once GitHub removes preview mode.
      github_client.add_team_membership(
        github_team,
        username,
        accept: PREVIEW_MEDIA_TYPE
      )
    end
  end

  def email_user
    if license_id
      license = License.find(license_id)
      LicenseMailer.fulfillment_error(license, username).deliver_now
    end
  end

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
