require 'spec_helper'

feature 'Visitor signs up for a subscription' do
  background do
    create_plan
  end

  scenario 'visitor signs up by navigating from landing page' do
    visit prime_path
    click_link I18n.t('subscriptions.join_cta')
    within("[data-sku='#{@plan.sku}']") do
      click_link I18n.t('subscriptions.choose_plan_html')
    end
    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_dashboard
    expect_to_see_purchase_success_flash_for(@plan.name)
  end

  scenario 'visitor attempts to subscribe and creates email/password user' do
    attempt_to_subscribe

    expect_to_be_on_subscription_purchase_page
    expect_to_see_password_required
    expect_to_see_email_required

    fill_out_subscription_form_with_valid_credit_card

    expect_to_see_password_error
    expect_to_see_email_error

    fill_out_account_creation_form
    fill_out_subscription_form_with_valid_credit_card

    expect(current_path).to be_the_dashboard
    expect_to_see_purchase_success_flash_for(@plan.name)
  end

  scenario 'visitor attempts to purchase with same email address that user exists in system' do
    existing_user = create(:user)

    attempt_to_subscribe
    expect_to_be_on_subscription_purchase_page

    fill_out_account_creation_form(name: existing_user.name, email: existing_user.email)
    fill_out_subscription_form_with_valid_credit_card

    expect_to_see_email_error("has already been taken")
  end

  scenario 'visitor attempts to subscribe and creates github user' do
    attempt_to_subscribe

    expect_to_be_on_subscription_purchase_page
    click_link 'with GitHub'

    expect_to_be_on_subscription_purchase_page

    expect(page).not_to have_content 'Password'

    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_dashboard
    expect_to_see_purchase_success_flash_for(@plan.name)
  end

  scenario 'visitor attempts to subscribe, signs in with github, but already has plan' do
    create(:user, :with_subscription, :with_github_auth)

    attempt_to_subscribe
    click_link 'Already have an account? Sign in'
    click_on 'Sign in with GitHub'

    expect(current_path).to be_the_dashboard
    expect(page).to have_css '.error', text: I18n.t('subscriber_purchase.flashes.error')
  end

  def expect_to_be_on_subscription_purchase_page
    expect(current_url).to eq new_individual_plan_purchase_url(@plan)
  end

  def expect_to_see_email_required
    expect(page).to have_css('#purchase_password_input abbr[title=required]')
  end

  def expect_to_see_password_required
    expect(page).to have_css('#purchase_password_input abbr[title=required]')
  end

  def expect_to_see_email_error(text = "can't be blank")
    expect(page).to have_css(
      '#purchase_email_input.error p.inline-errors',
      text: text
    )
  end

  def expect_to_see_password_error
    expect(page).to have_css(
      '#purchase_password_input.error p.inline-errors',
      text: "can't be blank"
    )
  end

  def create_plan
    @plan = create(:plan, sku: IndividualPlan::PRIME_99_SKU)
  end

  def attempt_to_subscribe
    visit new_individual_plan_purchase_path(@plan)
  end
end
