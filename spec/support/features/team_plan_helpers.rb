module Features
  def visit_team_plan_purchase_page
    plan = create(:team_plan)
    visit new_subscription_path
    click_link plan.name
  end
end
