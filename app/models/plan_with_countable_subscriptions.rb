module PlanWithCountableSubscriptions
  def subscription_count
    subscriptions.active.paid.count
  end
end
