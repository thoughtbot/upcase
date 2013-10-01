widget :prime_basic_subscriber_count do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: IndividualPlan.prime_basic.subscription_count
    }
  end
end
