require 'spec_helper'

feature 'User creates a team subscription' do
  background do
    create_team_plan
    create_mentors
    sign_in
  end

  scenario 'creates a team subscription with a valid credit card' do
    subscribe_with_valid_credit_card

    expect(current_user).to have_active_subscription
    expect(current_path).to eq dashboard_path
    expect(page).
      to have_content(I18n.t('purchase.flashes.success', name: plan.name))
    expect(FakeStripe.customer_plan_quantity).to eq plan.minimum_quantity.to_s
  end

  scenario 'sees that the subscription is per month' do
    visit_team_plan_purchase_page

    expect_submit_button_to_contain('per month')
  end

  scenario 'sees that the default quantity is 5' do
    visit_team_plan_purchase_page

    expect(field_labeled('Number of team members').value).
      to eq plan.minimum_quantity.to_s
  end

  scenario 'creates a team subscription with more members', js: true do
    requested_quantity = '6'

    visit_team_plan_purchase_page

    expect_submit_button_to_contain("$445 per month")

    select requested_quantity, from: 'Number of team members'

    expect_submit_button_to_contain("$534 per month")

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to eq dashboard_path
    expect(FakeStripe.customer_plan_quantity).to eq requested_quantity
  end

  scenario 'creates a Stripe subscription with a valid amount off coupon', js: true do
    create_amount_stripe_coupon('5OFF', 'once', 500)

    visit_team_plan_purchase_page

    expect_submit_button_to_contain("$445 per month")

    apply_coupon_with_code('5OFF')

    expect_submit_button_to_contain discount_text('440.00', '445.00')

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(FakeStripe.last_coupon_used).to eq '5OFF'
    expect(FakeStripe.customer_plan_quantity).to eq plan.minimum_quantity.to_s
  end

  scenario 'does not see the option to pay with paypal' do
    visit_team_plan_purchase_page
    click_prime_call_to_action_in_header

    expect(page).not_to have_css('#purchase_payment_method_paypal')
  end

  scenario "user without github username sees github username input" do
    current_user.github_username = nil
    current_user.save!

    visit_team_plan_purchase_page

    expect(page).to have_content('GitHub username')
    expect(page).to have_css('input#github_username_1')
  end

  scenario "user with github username doesn't see github username input" do
    current_user.github_username = 'cpyteltest'
    current_user.save!

    visit_team_plan_purchase_page

    expect(page).not_to have_content('GitHub username')
    expect(page).not_to have_css('input#github_username_1')
  end

  scenario 'creates a Stripe subscription with a valid amount off coupon', js: true do
    create_amount_stripe_coupon('5OFF', 'once', 500)

    visit_team_plan_purchase_page

    expect_submit_button_to_contain("$445 per month")

    apply_coupon_with_code('5OFF')

    expect_submit_button_to_contain discount_text('440.00', '445.00')

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to eq dashboard_path
    expect(page).to have_content(I18n.t('purchase.flashes.success', name: plan.name))
    expect(FakeStripe.last_coupon_used).to eq '5OFF'
  end

  scenario 'tries to subscribe with an invalid coupon', :js => true do
    visit_team_plan_purchase_page

    expect_submit_button_to_contain('$445 per month')

    apply_coupon_with_code('5OFF')

    expect(page).to have_content('The coupon code you supplied is not valid.')
  end

  def visit_team_plan_purchase_page
    visit team_plans_path
    click_link('Choose')
  end

  def create_team_plan
    @plan = create(:team_plan)
  end

  def subscribe_with_valid_credit_card
    visit_team_plan_purchase_page
    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER
  end

  def subscribe_with_invalid_credit_card
    visit_team_plan_purchase_page
    FakeStripe.failure = true
    fill_out_subscription_form_with 'bad cc number'
  end

  def plan
    @plan
  end

  def apply_coupon_with_code(code)
    click_link "Have a coupon code?"
    fill_in "Code", with: code
    click_button "Apply Coupon"
  end

  def discount_text(new, original)
    I18n.t(
      'subscriptions.discount.once',
      final_price: new,
      full_price: original,
    )
  end

  def expect_to_see_the_current_plan(plan)
    expect(page).to have_css(
      '.subscription p strong',
      text: plan.name
    )
  end
end
