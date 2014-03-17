class GitHubPublicKeyDownloadFulfillmentJob
  PRIORITY = 1

  def self.enqueue(user_id)
    Delayed::Job.enqueue(
      GitHubPublicKeyDownloadFulfillmentJob.new(user_id),
      priority: PRIORITY
    )
  end

  def initialize(user_id)
    @user_id = user_id
  end

  def perform
    GitHubPublicKeyDownloadFulfillment.new(user).fulfill
  end

  private

  def user
    User.find(@user_id)
  end
end
