class Reactivation
  def initialize(subscription:)
    @subscription = subscription
  end

  attr_reader :subscription

  def fulfill
    can_fulfill? && fulfill_reactivation
  end

  private

  def fulfill_reactivation
    subscription.reactivate
  end

  def can_fulfill?
    subscription.scheduled_for_deactivation?
  end
end
