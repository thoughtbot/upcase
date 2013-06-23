class SubscriptionFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    if @purchase.subscription?
      @purchase.user.create_subscription
    end
  end
end
