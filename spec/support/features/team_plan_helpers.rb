module Features
  def visit_team_plan_checkout_page
    plan = create(:plan, :team)
    visit new_checkout_path(plan)
  end
end
