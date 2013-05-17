widget :prime_churn do
  key "6956919dc8546968e7521b4009b19f5435e7cfc1"
  type "number_and_secondary"
  data do
    {
      value: SubscriptionMetrics.current_churn,
      previous: SubscriptionMetrics.previous_churn
    }
  end
end
