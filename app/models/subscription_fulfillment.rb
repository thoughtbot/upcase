class SubscriptionFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    if @purchase.subscription?
      @purchase.user.assign_mentor(mentor)
      @purchase.user.create_subscription(
        plan: @purchase.purchaseable,
      )
    end
  end

  private

  def mentor
    Mentor.find_or_sample(@purchase.mentor_id)
  end
end
