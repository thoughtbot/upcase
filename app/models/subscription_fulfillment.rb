class SubscriptionFulfillment
  def initialize(user, plan)
    @user = user
    @plan = plan
  end

  def fulfill
    fulfill_gained_features
    download_public_keys
  end

  def remove
    unfulfill_lost_features
    deactivate_subscription_purchases
  end

  private

  def fulfill_gained_features
    FeatureFulfillment.new(
      old_plan: NullPlan.new,
      new_plan: @plan,
      user: @user
    ).fulfill_gained_features
  end

  def unfulfill_lost_features
    FeatureFulfillment.new(
      old_plan: @plan,
      new_plan: NullPlan.new,
      user: @user
    ).unfulfill_lost_features
  end

  def download_public_keys
    GitHubPublicKeyDownloadFulfillmentJob.enqueue(@user.id)
  end

  def deactivate_subscription_purchases
    @user.subscription_purchases.each do |purchase|
      PurchaseRefunder.new(purchase).refund
    end
  end
end
