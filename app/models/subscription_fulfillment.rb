class SubscriptionFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    if @purchase.subscription?
      @purchase.user.create_subscription(
        stripe_plan_id: @purchase.purchaseable_sku
      )
    end
  end
end
