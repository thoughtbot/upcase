widget :prime do
  key "35d48b88f4e636eb9c575bf8e0498cbcaf949b45"
  type "number_and_secondary"
  data do
    {
      value: SubscriptionMetrics.total_subscribers_as_of(Time.zone.now),
      previous: SubscriptionMetrics.total_subscribers_as_of(30.days.ago)
    }
  end
end
