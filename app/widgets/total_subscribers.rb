widget :total_subscribers do
  key "24556fbc12af7ea8e01ba859c048152986722825"
  type "number_and_secondary"
  data do
    {
      value: Plan.prime_basic_subscription_count + Plan.prime_workshops_subscription_count + Plan.prime_with_mentoring_subscription_count
    }
  end
end
