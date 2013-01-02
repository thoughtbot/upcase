class RemoveGithubTeamMemberJob < Struct.new(:github_team, :username)
  PRIORITY = 1

  def self.enqueue(github_team, username)
    Delayed::Job.enqueue(new(github_team, username))
  end

  def perform
    begin
      github_client.remove_team_member(github_team, username)
    rescue Octokit::NotFound, Net::HTTPBadResponse => e
      Airbrake.notify(e)
    end
  end

  private

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
