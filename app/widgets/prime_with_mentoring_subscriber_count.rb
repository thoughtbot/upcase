widget :prime_with_mentoring_subscriber_count do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: IndividualPlan.prime_with_mentoring.subscription_count
    }
  end
end
