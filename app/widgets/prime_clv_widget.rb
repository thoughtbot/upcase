widget :prime_clv do
  key "6956919dc8546968e7521b4009b19f5435e7cfc1"
  type "number_and_secondary"
  data do
    {
      value: SubscriptionMetrics.current_ltv,
      previous: SubscriptionMetrics.previous_ltv,
    }
  end
end
