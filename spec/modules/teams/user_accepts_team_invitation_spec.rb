require 'rails_helper'

feature 'Accept team invitations' do
  scenario 'and signs up' do
    visit_team_plan_checkout_page
    fill_out_account_creation_form email: 'owner@somedomain.com'
    fill_out_credit_card_form_with_valid_credit_card

    fill_in 'Email', with: 'invited-member@example.com'
    click_on 'Send'

    using_session :team_member do
      open_email 'invited-member@example.com'
      click_first_link_in_email

      fill_in 'Name', with: 'Team Member'
      fill_in 'Github username', with: 'tmember'
      fill_in 'Password', with: 'secret'
      click_on 'Create an account'

      click_on 'Settings'

      expect(page).to have_field('Email', with: 'invited-member@example.com')
      expect(page).to have_content('Team: Somedomain')
    end
  end

  scenario 'and fills in the form incorrectly' do
    visit_team_plan_checkout_page
    fill_out_account_creation_form email: 'owner@somedomain.com'
    fill_out_credit_card_form_with_valid_credit_card

    fill_in 'Email', with: 'invited-member@example.com'
    click_on 'Send'

    using_session :team_member do
      open_email 'invited-member@example.com'
      click_first_link_in_email

      fill_in 'Name', with: 'Team Member'
      fill_in 'Github username', with: 'tmember'
      click_on 'Create an account'

      expect(page).to have_content("can't be blank")

      fill_in 'Password', with: 'secret'
      click_on 'Create an account'

      expect(page).to have_content('Dashboard')
    end
  end
end
