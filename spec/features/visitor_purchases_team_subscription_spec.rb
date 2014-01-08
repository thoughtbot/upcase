require 'spec_helper'

feature 'Visitor can purchase a subscription for their team' do
  scenario 'successful purchase' do
    create(:mentor)
    team_plan = create(:team_plan, name: 'Featured', description: 'Awesome')
    hidden_team_plan = create(:team_plan, name: 'Not Featured', featured: false)

    visit new_subscription_path

    expect_to_see_featured_team_plans

    click_link team_plan.name

    fill_out_account_creation_form email: 'user@fabtabulous.com'
    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_purchase_success_flash_for(team_plan.name)

    click_link 'Settings'

    expect_to_see_team_name 'Fabtabulous'
  end

  def expect_to_see_featured_team_plans
    TeamPlan.featured.each do |team_plan|
      expect(page).to have_content team_plan.name
      expect(page).to have_content team_plan.description
    end

    TeamPlan.where(featured: false).each do |team_plan|
      within '.plans' do
        expect(page).not_to have_content team_plan.name
      end
    end
  end

  def expect_to_see_team_name(team_name)
    expect(page).to have_content(team_name)
  end
end
