widget :team_plan_churn do
  key ENV['WIDGETS_API_KEY']
  type "number_and_secondary"
  data do
    {
      value: TeamPlan.instance.current_churn
    }
  end
end
