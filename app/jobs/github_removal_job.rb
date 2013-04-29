class GithubRemovalJob < Struct.new(:github_team, :usernames)
  include ErrorReporting

  PRIORITY = 1
  API_SLEEP_TIME = 0.2

  def self.enqueue(github_team, usernames)
    Delayed::Job.enqueue(new(github_team, usernames))
  end

  def perform
    usernames.each do |username|
      begin
        github_client.remove_team_member(github_team, username)
      rescue Octokit::NotFound, Net::HTTPBadResponse => e
        Airbrake.notify(e)
      end
      sleep API_SLEEP_TIME
    end
  end

  private

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
