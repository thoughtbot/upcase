widget :total_churn do
  key "24556fbc12af7ea8e01ba859c048152986722825"
  type "number_and_secondary"
  data do
    {
      value: TotalChurn.new([
        IndividualPlan.prime_basic,
        IndividualPlan.prime_workshops,
        IndividualPlan.prime_with_mentoring,
        TeamPlan.instance
      ]).current
    }
  end
end
