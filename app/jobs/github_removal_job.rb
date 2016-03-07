class GithubRemovalJob < Struct.new(:repository, :username)
  include ErrorReporting

  PRIORITY = 1

  def self.enqueue(repository, username)
    Delayed::Job.enqueue(new(repository, username))
  end

  def perform
    begin
      github_client.remove_collaborator(repository, username)
    rescue Octokit::NotFound, Net::HTTPBadResponse => e
      Honeybadger.notify(e)
    end
  end

  private

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
