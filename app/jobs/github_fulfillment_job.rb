class GithubFulfillmentJob < Struct.new(:github_team, :username, :purchase_id)
  include ErrorReporting

  PRIORITY = 1
  API_SLEEP_TIME = 0.2

  def self.enqueue(github_team, usernames, purchase_id=nil)
    usernames.each do |username|
      job = new(github_team, username, purchase_id)
      Delayed::Job.enqueue(job, :run_at => API_SLEEP_TIME.seconds.from_now)
    end
  end

  def perform
    github_client.add_team_member(github_team, username)
  rescue Octokit::NotFound, Net::HTTPBadResponse
    email_purchaser
    raise
  end

  private

  def email_purchaser
    if purchase_id
      purchase = Purchase.find(purchase_id)
      PurchaseMailer.fulfillment_error(purchase, username).deliver
    end
  end

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
