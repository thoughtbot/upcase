class GithubFulfillmentJob < Struct.new(:github_team, :usernames, :purchase_id)
  include ErrorReporting

  PRIORITY = 1
  API_SLEEP_TIME = 0.2

  def self.enqueue(github_team, usernames, purchase_id)
    Delayed::Job.enqueue(new(github_team, usernames, purchase_id))
  end

  def perform
    usernames.each do |username|
      begin
        github_client.add_team_member(github_team, username)
      rescue Octokit::NotFound, Net::HTTPBadResponse => e
        report_error(e, username)
      end
      sleep API_SLEEP_TIME
    end
  end

  private

  def report_error(e, username)
    purchase = Purchase.find(purchase_id)
    Mailer.fulfillment_error(purchase, username).deliver
    Airbrake.notify(e)
  end

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
