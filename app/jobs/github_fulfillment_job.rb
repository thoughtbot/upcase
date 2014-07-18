class GithubFulfillmentJob < Struct.new(:github_team, :username, :license_id)
  include ErrorReporting

  PRIORITY = 1

  def self.enqueue(github_team, username, license_id=nil)
    Delayed::Job.enqueue(new(github_team, username, license_id))
  end

  def perform
    github_client.add_team_member(github_team, username)
  rescue Octokit::NotFound, Net::HTTPBadResponse
    email_user
    raise
  end

  private

  def email_licenser
    if license_id
      license = License.find(license_id)
      LicenseMailer.fulfillment_error(license, username).deliver
    end
  end

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
