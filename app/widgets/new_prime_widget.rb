widget :new_prime do
  key "35d48b88f4e636eb9c575bf8e0498cbcaf949b45"
  type "number_and_secondary"
  data do
    {
      value: SubscriptionMetrics.new_in_period(30.days.ago, Time.now),
      previous: SubscriptionMetrics.new_in_period(60.days.ago, 30.days.ago)
    }
  end
end
