require 'spec_helper'

feature 'Visitor can purchase a subscription for their team' do
  scenario 'successful purchase' do
    create(:mentor)
    team_plan = create(:team_plan)

    visit new_subscription_path
    click_link I18n.t('shared.company_subscription_call_to_action')

    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_purchase_success_flash_for(team_plan.name)
  end
end
