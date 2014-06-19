require 'spec_helper'

feature 'User creates a subscription' do
  background do
    create_plan
    sign_in
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

    expect(page).to have_github_input
  end

  scenario "user with github username doesn't see github username input" do
    current_user.github_username = 'cpyteltest'
    current_user.save!

    visit_plan_purchase_page

    expect(page).not_to have_github_input
  end

  scenario 'creates a Stripe subscription with a valid amount off coupon', js: true do
    create_amount_stripe_coupon('5OFF', 'once', 500)

    visit_plan_purchase_page

    expect_submit_button_to_contain("$99 per month")

    apply_coupon_with_code('5OFF')

    expect_submit_button_to_contain discount_text('94.00', '99.00')

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to be_the_dashboard
    expect_to_see_purchase_success_flash_for(@plan.name)
    expect(FakeStripe.last_coupon_used).to eq '5OFF'
  end

  scenario 'creates a Stripe subscription with a free month coupon', js: true do
    create_recurring_stripe_coupon('THREEFREE', 3, 9900)

    visit_plan_purchase_page

    expect_submit_button_to_contain("$99 per month")

    apply_coupon_with_code('THREEFREE')

    expect_submit_button_to_contain("$0.00 for 3 months, then $99.00")

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect_to_see_purchase_success_flash_for(@plan.name)
    expect(FakeStripe.last_coupon_used).to eq 'THREEFREE'
  end

  scenario 'creates a Stripe subscription with a valid percentage off coupon', js: true do
    create_percentage_off_stripe_coupon('50OFF', 'once', 50)

    visit_plan_purchase_page

    expect_submit_button_to_contain("$99 per month")

    apply_coupon_with_code('50OFF')

    expect_submit_button_to_contain discount_text('49.50', '99.00')

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect_to_see_purchase_success_flash_for(@plan.name)
    expect(FakeStripe.last_coupon_used).to eq '50OFF'
    expect(current_path).to be_the_dashboard
    expect(Purchase.last.stripe_customer_id).to be_present
  end

  scenario 'creates a Stripe subscription with an invalid coupon', :js => true do
    visit_plan_purchase_page

    expect_submit_button_to_contain('$99 per month')

    click_link 'Have a coupon code?'
    fill_in 'Code', with: '5OFF'
    click_button 'Apply Coupon'

    expect(page).to have_content('The coupon code you supplied is not valid.')
  end

  scenario 'sees option to update billing for subscribers' do
    sign_in_as_user_with_subscription
    visit my_account_path

    expect(page).to have_content('Your Billing Info')
  end

  scenario 'changes subscription plan' do
    new_plan = create(:plan, name: 'New Plan', sku: 'new-plan')
    sign_in_as_user_with_subscription
    visit my_account_path

    expect_to_see_the_current_plan(current_user.subscription.plan)

    click_link I18n.t('subscriptions.change_plan')
    click_link new_plan.name

    expect(current_path).to eq my_account_path
    expect_to_see_the_current_plan(new_plan)
    expect(page).to have_content(I18n.t('subscriptions.flashes.change.success'))
    expect(FakeStripe.customer_plan_id).to eq 'new-plan'
  end

  scenario 'does not see option to update billing if not subscribing' do
    visit my_account_path

    expect(page).not_to have_content('Your Billing Info')
  end

  scenario 'does not see call out to subscribe if already subscribed' do
    plan = create(:plan, name: 'Prime')
    create(:workshop, name: 'A Cool Workshop')
    sign_in_as_user_with_subscription

    visit products_path

    expect(find('.header-container')).not_to have_content(
      "#{plan.name} Membership"
    )

    click_link 'View Details'

    expect(page).not_to have_link("Subscribe to #{plan.name}")
  end

  def visit_plan_purchase_page
    visit new_individual_plan_purchase_path(@plan)
  end

  def create_plan
    @plan = create(:plan)
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

  def have_github_input
    have_content('GitHub username') &&
      have_css('input#github_username_1')
  end
end
