class SubscriptionFulfillment
  def initialize(purchase, user)
    @purchase = purchase
    @user = user
  end

  def fulfill
    fulfill_gained_features
    create_subscription
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
      new_plan: @purchase.purchaseable,
      user: @user
    ).fulfill_gained_features
  end

  def unfulfill_lost_features
    FeatureFulfillment.new(
      old_plan: @purchase.purchaseable,
      new_plan: NullPlan.new,
      user: @user
    ).unfulfill_lost_features
  end

  def create_subscription
    if purchaser?
      @user.create_purchased_subscription(plan: @purchase.purchaseable)
    end
  end

  def purchaser?
    @purchase.user == @user
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
