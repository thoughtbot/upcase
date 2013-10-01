widget :total_subscribers do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: IndividualPlan.prime_basic.subscription_count +
        IndividualPlan.prime_workshops.subscription_count +
        IndividualPlan.prime_with_mentoring.subscription_count +
        TeamPlan.instance.subscription_count
    }
  end
end
