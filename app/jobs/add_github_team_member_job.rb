class AddGithubTeamMemberJob < Struct.new(:github_team, :username, :purchase_id)
  include ErrorReporting

  PRIORITY = 1

  def self.enqueue(github_team, username, purchase_id)
    Delayed::Job.enqueue(new(github_team, username, purchase_id))
  end

  def perform
    begin
      github_client.add_team_member(github_team, username)
    rescue Octokit::NotFound, Net::HTTPBadResponse => e
      report_error(e)
    end
  end

  private

  def report_error(e)
    purchase = Purchase.find(purchase_id)
    Mailer.fulfillment_error(purchase, username).deliver
    Airbrake.notify(e)
  end

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
