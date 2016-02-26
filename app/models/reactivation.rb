class Reactivation
  def initialize(subscription:)
    @subscription = subscription
  end

  def fulfill
    @subscription.reactivate
  end
end
