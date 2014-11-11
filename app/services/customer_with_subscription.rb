class CustomerWithSubscription
  def initialize(stripe_customer)
    @stripe_customer = stripe_customer
  end

  def has_out_of_sync_user?
    upcase_user.present? && plan_mismatched?
  end

  def to_s
    <<-EOS.squish
    Customer #{stripe_customer["id"]} has subscription #{stripe_plan_id} in
    Stripe, and #{upcase_plan_sku} in Upcase
    EOS
  end

  private

  def upcase_user
    @upcase_user ||= User.find_by(stripe_customer_id: stripe_customer["id"])
  end

  attr_reader :stripe_customer

  def plan_mismatched?
    upcase_plan_sku != stripe_plan_id
  end

  def upcase_plan_sku
    @upcase_plan_sku ||= upcase_user.try(:subscription).try(:plan).try(:sku)
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
