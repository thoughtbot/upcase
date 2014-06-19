module Features
  def visit_team_plan_purchase_page
    plan = create(:team_plan)
    visit new_teams_team_plan_purchase_path(plan)
  end
end
