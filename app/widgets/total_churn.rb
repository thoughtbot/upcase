widget :total_churn do
  key ENV['WIDGETS_API_KEY']
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
