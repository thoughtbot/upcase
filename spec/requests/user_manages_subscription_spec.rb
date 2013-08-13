require 'spec_helper'

feature 'User creates a subscription' do

  VALID_SANDBOX_CREDIT_CARD_NUMBER = '4111111111111111'

  background do
    create_plan
    create_mentors
    sign_in
  end

  scenario 'creates a Stripe subscription with a valid credit card' do
    subscribe_with_valid_credit_card
    expect(current_user).to have_active_subscription
    expect(current_path).to eq products_path
    expect(page).to have_content(I18n.t('purchase.flashes.success', name: plan.name))
  end

  scenario 'does not create a Stripe subscription with an invalid credit card' do
    subscribe_with_invalid_credit_card
    expect(current_user).not_to have_active_subscription
  end

  scenario 'sees that the subscription is per month' do
    visit_plan_purchase_page

    expect_submit_button_to_contain('per month')
  end

  scenario 'does not see the option to pay with paypal' do
    visit_plan_purchase_page
    click_prime_call_to_action_in_header

    expect(page).not_to have_css('#purchase_payment_method_paypal')
  end

  scenario "user without github username sees github username input" do
    current_user.github_username = nil
    current_user.save!

    visit_plan_purchase_page

    expect(page).to have_content('GitHub username')
    expect(page).to have_css('input#github_username_1')
  end

  scenario "user with github username doesn't see github username input" do
    current_user.github_username = 'cpyteltest'
    current_user.save!

    visit_plan_purchase_page

    expect(page).not_to have_content('GitHub username')
    expect(page).not_to have_css('input#github_username_1')
  end

  scenario 'creates a Stripe subscription with a valid coupon', :js => true do
    create_amount_stripe_coupon('5OFF', 'once', 500)

    visit_plan_purchase_page

    expect_submit_button_to_contain("$15 per month")

    click_link "Have a coupon code?"
    fill_in "Code", with: '5OFF'
    click_button "Apply Coupon"

    expect_submit_button_to_contain("$10.00 the first month, then $15.00 per month")

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to eq products_path
    expect(page).to have_content(I18n.t('purchase.flashes.success', name: plan.name))
  end

  scenario 'creates a Stripe subscription with a free month coupon', :js => true do
    create_recurring_stripe_coupon('THREEFREE', 3, 1500)

    visit_plan_purchase_page

    expect_submit_button_to_contain("$15 per month")

    click_link "Have a coupon code?"
    fill_in "Code", with: 'THREEFREE'
    click_button "Apply Coupon"

    expect_submit_button_to_contain("$0.00 for 3 months, then $15.00 per month")

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to eq products_path
    expect(Purchase.last.stripe_customer_id).to be_present
  end

  scenario 'creates a Stripe subscription with an invalid coupon', :js => true do
    visit_plan_purchase_page

    expect_submit_button_to_contain('$15 per month')

    click_link 'Have a coupon code?'
    fill_in 'Code', with: '5OFF'
    click_button 'Apply Coupon'

    expect(page).to have_content('The coupon code you supplied is not valid.')
  end

  scenario 'sees option to update billing for subscribers' do
    sign_in_as_subscriber
    visit my_account_path

    expect(page).to have_content('Your Billing Info')
  end

  scenario 'updates Stripe subscription', js: true do
    sign_in_as_subscriber
    visit my_account_path
    submit_new_credit_card_info

    expect(current_path).to eq my_account_path
    expect(page).to have_content(I18n.t('subscriptions.flashes.update.success'))
  end

  scenario 'updates Stripe subscription with declining credit card', js: true do
    FakeStripe.failure = true
    sign_in_as_subscriber
    visit my_account_path
    submit_declining_credit_card_info

    expect(current_path).to eq my_account_path
    expect(page).to_not have_content(I18n.t('subscriptions.flashes.update.success'))
    expect(page).to have_content 'Your credit card was declined'
  end

  scenario 'does not see option to update billing if not subscribing' do
    visit my_account_path

    expect(page).not_to have_content('Your Billing Info')
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

  def visit_plan_purchase_page
    visit new_subscription_path
    click_link('Choose')
  end

  def create_plan
    @plan = create(:plan)
  end

  def sign_in
    @current_user = create(:user)
    visit root_path(as: @current_user)
  end

  def sign_in_as_subscriber
    subscriber = create(:user, :with_subscription)
    visit root_path(as: subscriber)
  end

  def subscribe_with_valid_credit_card
    visit_plan_purchase_page
    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER
  end

  def subscribe_with_invalid_credit_card
    visit_plan_purchase_page
    FakeStripe.failure = true
    fill_out_subscription_form_with 'bad cc number'
  end

  def current_user
    @current_user
  end

  def plan
    @plan
  end

  def create_amount_stripe_coupon(id, duration, amount_off)
    Stripe::Coupon.create(
      :id => id,
      :duration => duration,
      :amount_off => amount_off
    )
  end

  def create_recurring_stripe_coupon(id, duration, amount_off)
    Stripe::Coupon.create(
      :id => id,
      :duration => 'repeating',
      :duration_in_months => duration,
      :amount_off => amount_off
    )
  end
end
