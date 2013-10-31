require 'spec_helper'

feature 'Visitor can purchase a subscription for their team' do
  scenario 'successful purchase' do
    create(:mentor)
    team_plan = create(:team_plan, description: 'Awesome plan')
    hidden_team_plan = create(:team_plan, featured: false)

    visit new_subscription_path
    click_link I18n.t('shared.company_subscription_call_to_action')

    expect_to_see_featured_team_plans

    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_purchase_success_flash_for(team_plan.name)
  end

  def expect_to_see_featured_team_plans
    TeamPlan.featured.each do |team_plan|
      expect(page).to have_content team_plan.name
      expect(page).to have_content team_plan.description
    end
    TeamPlan.where(featured: false).each do |team_plan|
      expect(page).not_to have_content team_plan.name
    end
  end
end
