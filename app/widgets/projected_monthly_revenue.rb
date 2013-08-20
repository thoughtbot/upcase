widget :projected_monthly_revenue do
  key "74b333b94cd772ee15be863e646f8ca1e535f1c6"
  type "number_and_secondary"
  data do
    {
      value:
        IndividualPlan.prime_basic.projected_monthly_revenue +
        IndividualPlan.prime_workshops.projected_monthly_revenue +
        IndividualPlan.prime_with_mentoring.projected_monthly_revenue +
        TeamPlan.instance.projected_monthly_revenue
    }
  end
end
