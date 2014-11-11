class CustomerWithSubscription
  def initialize(stripe_customer)
    @stripe_customer = stripe_customer
  end

  def has_out_of_sync_user?
    user.present? && plan_mismatched?
  end

  def update_subscription_stripe_id
    if subscription
      subscription.update(stripe_id: stripe_subscription["id"])
    end
  end

  def to_s
    <<-EOS.squish
    Customer #{stripe_customer["id"]} has subscription #{stripe_plan_id} in
    Stripe, and #{plan_sku} in Upcase
    EOS
  end

  private

  def user
    User.find_by(stripe_customer_id: stripe_customer["id"])
  end

  attr_reader :stripe_customer

  def plan_mismatched?
    plan_sku != stripe_plan_id
  end

  def plan_sku
    subscription.try(:plan).try(:sku)
  end

  def subscription
    user.try(:subscription)
  end

  def stripe_plan_id
    if stripe_subscription
      stripe_subscription["plan"]["id"]
    end
  end

  def stripe_subscription
    @stripe_subscription ||= stripe_subscriptions.first
  end

  def stripe_subscriptions
    stripe_customer["subscriptions"]["data"]
  end
end
