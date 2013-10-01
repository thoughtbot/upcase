widget :prime_workshops_ltv do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: IndividualPlan.prime_workshops.current_ltv
    }
  end
end
