class Metrics
  def initialize(subscription_relation=Subscription)
    @subscription_relation = subscription_relation
  end

  def subscription_signups_since(date)
    @subscription_relation.where(created_at: (date..Time.zone.now))
  end
end
