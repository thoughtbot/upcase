widget :team_plan_subscriber_count do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: TeamPlan.instance.subscription_count
    }
  end
end
