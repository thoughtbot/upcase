widget :total_subscribers do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    { value: total_monthly_prime_subscribers + total_yearly_prime_subscribers }
  end

  def total_monthly_prime_subscribers
    IndividualPlan.prime_basic.subscription_count +
    IndividualPlan.prime_workshops.subscription_count +
    IndividualPlan.prime_with_mentoring.subscription_count +
    TeamPlan.instance.subscription_count
  end

  def total_yearly_prime_subscribers
    IndividualPlan.prime_basic_yearly.subscription_count +
    IndividualPlan.prime_workshops_yearly.subscription_count
  end
end
