module Features
  def visit_team_plan_checkout_page
    plan = create(:team_plan)
    visit new_checkout_path(plan)
  end
end
