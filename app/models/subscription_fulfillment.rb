class SubscriptionFulfillment
  GITHUB_TEAM = 516450

  def initialize(purchase, user)
    @purchase = purchase
    @user = user
  end

  def fulfill
    assign_mentor
    create_subscription
    add_user_to_github_team
    download_public_keys
  end

  def remove
    remove_user_from_github_team
    deactivate_subscription_purchases
  end

  private

  def assign_mentor
    @user.assign_mentor(mentor)
  end

  def create_subscription
    if purchaser?
      @user.create_purchased_subscription(plan: @purchase.purchaseable)
    end
  end

  def purchaser?
    @purchase.user == @user
  end

  def add_user_to_github_team
    GithubFulfillmentJob.enqueue(GITHUB_TEAM, [@user.github_username])
  end

  def download_public_keys
    GitHubPublicKeyDownloadFulfillmentJob.enqueue(@user.id)
  end

  def remove_user_from_github_team
    GithubRemovalJob.enqueue(GITHUB_TEAM, [@user.github_username])
  end

  def deactivate_subscription_purchases
    @user.subscription_purchases.each do |purchase|
      PurchaseRefunder.new(purchase).refund
    end
  end

  def mentor
    Mentor.find_or_sample(@purchase.mentor_id)
  end
end
