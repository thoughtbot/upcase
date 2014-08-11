require "rails_helper"

feature 'Send team invitations' do
  scenario 'with valid data' do
    subscribe_to_team_plan
    invite 'invited-member@example.com'

    expect(page).to have_success_message
  end

  scenario 'and fills in the form incorrectly' do
    subscribe_to_team_plan
    invite ''

    expect(page).to have_error_message

    invite 'someone@example.com'

    expect(page).to have_success_message
  end

  def subscribe_to_team_plan
    visit_team_plan_checkout_page
    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card
  end

  def invite(email)
    fill_in 'Email', with: email
    click_on 'Send'
  end

  def have_success_message
    have_content('Invitation sent.')
  end

  def have_error_message
    have_content("can't be blank")
  end
end
