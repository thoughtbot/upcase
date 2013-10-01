require 'spec_helper'

feature 'User updated credit card' do
  background do
    create_plan
    create_mentors
  end

  scenario 'updates credit card information', js: true do
    sign_in_as_user_with_subscription
    visit my_account_path
    submit_new_credit_card_info

    expect(current_path).to eq my_account_path
    expect(page).to have_content(I18n.t('subscriptions.flashes.update.success'))
  end

  scenario 'updates Stripe subscription with declining credit card', js: true do
    FakeStripe.failure = true
    sign_in_as_user_with_subscription
    visit my_account_path
    submit_declining_credit_card_info

    expect(current_path).to eq my_account_path
    expect(page).to_not have_content(I18n.t('subscriptions.flashes.update.success'))
    expect(page).to have_content 'Your credit card was declined'
  end

  def create_plan
    @plan = create(:plan)
  end

  def submit_new_credit_card_info
    credit_card_expires_on = Time.now.advance(years: 1)
    month_selection = credit_card_expires_on.strftime('%-m - %B')

    year_selection = credit_card_expires_on.strftime('%Y')
    valid_cc_num = '4242424242424242'

    fill_in 'Card Number', with: valid_cc_num
    select month_selection, from: 'date[month]'
    select year_selection, from: 'date[year]'
    fill_in 'CVC', with: '333'
    click_button 'Update Your Card'
  end

  def submit_declining_credit_card_info
    credit_card_expires_on = Time.now.advance(years: 1)
    month_selection = credit_card_expires_on.strftime('%-m - %B')

    year_selection = credit_card_expires_on.strftime('%Y')
    declining_cc_num = '4000 0000 0000 0069'

    fill_in 'Card Number', with: declining_cc_num
    select month_selection, from: 'date[month]'
    select year_selection, from: 'date[year]'
    fill_in 'CVC', with: '333'
    click_button 'Update Your Card'
  end
end
