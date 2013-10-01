widget :prime_with_mentoring_ltv do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: IndividualPlan.prime_with_mentoring.current_ltv
    }
  end
end
