class Resubscription
  def initialize(user:, plan:)
    @user = user
    @plan = plan
  end

  attr_reader :user, :plan

  def fulfill
    if former_subscriber?
      stripe_subscription_id = create_new_stripe_subscription
      create_new_app_subscription(stripe_subscription_id)
      true
    end
  end

  private

  def former_subscriber?
    has_no_subscription? && stripe_customer?
  end

  def has_no_subscription?
    !user.subscriber?
  end

  def stripe_customer?
    user.has_credit_card?
  end

  def create_new_stripe_subscription
    stripe_customer.subscriptions.create(plan: plan.sku).id
  end

  def create_new_app_subscription(stripe_subscription_id)
    user.subscriptions.create(plan: plan, stripe_id: stripe_subscription_id)
  end

  def stripe_customer
    StripeCustomerFinder.retrieve(user.stripe_customer_id)
  end
end
