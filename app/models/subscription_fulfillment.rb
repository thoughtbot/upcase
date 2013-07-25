class SubscriptionFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    if @purchase.subscription?
      @purchase.user.create_subscription(
        plan: @purchase.purchaseable,
        mentor: mentor
      )
    end
  end

  private

  def mentor
    if @purchase.mentor_id.present?
      User.find(@purchase.mentor_id)
    else
      User.mentors.sample
    end
  end
end
