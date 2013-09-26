widget :team_plan_churn do
  key "5b353a45f195e2ca9b6ce81c90f8c4a24621be5a"
  type "number_and_secondary"
  data do
    {
      value: TeamPlan.instance.current_churn
    }
  end
end
