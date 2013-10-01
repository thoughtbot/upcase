widget :prime_workshops_churn do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: IndividualPlan.prime_workshops.current_churn
    }
  end
end
