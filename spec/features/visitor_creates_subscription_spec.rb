require "rails_helper"

feature 'Visitor signs up for a subscription' do
  include VanityHelpers

  background do
    create_plan
    stub_ab_test_result(:landing_page, :existing)
  end

  scenario 'visitor signs up by navigating from landing page' do
    create(:trail, :published)

    visit "/"
    click_link "Start Learning"
    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
    expect(vanity_signup_count).to eq 1
  end

  scenario "visitor signs up by navigating from new landing page" do
    stub_ab_test_result(:landing_page, :new)
    create(:trail, :published)

    visit root_path
    click_link I18n.t("pages.landing.sign_up_cta")
    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
    expect(vanity_signup_count).to eq 1
  end

  scenario "Visitor signs in with email and password while checking out" do
    user = create(:user, password: "password")
    attempt_to_subscribe

    click_link 'Already have an account? Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    expect_to_be_on_checkout_page
    expect(page).to have_no_field "Name"
    expect(page).to have_no_field "Email"
    expect(page).to have_content "Sign out"
  end

  scenario 'visitor attempts to subscribe and creates email/password user' do
    attempt_to_subscribe

    expect_to_be_on_checkout_page
    expect_to_see_required :name
    expect_to_see_required :password
    expect_to_see_required :email
    expect_to_see_required :github_username

    fill_out_subscription_form_with_valid_credit_card

    expect_to_see_password_error
    expect_to_see_email_error

    fill_out_account_creation_form
    fill_out_subscription_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
  end

  scenario "without specifying a GitHub username" do
    attempt_to_subscribe

    user = build(:user)
    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button "Submit Payment"

    expect(page).to have_css("li.error input#checkout_github_username")
  end

  scenario 'visitor attempts to subscribe with same email address that user exists in system' do
    existing_user = create(:user)

    attempt_to_subscribe
    expect_to_be_on_checkout_page

    fill_out_account_creation_form(name: existing_user.name, email: existing_user.email)
    fill_out_subscription_form_with_valid_credit_card

    expect_to_see_email_error("has already been taken")
  end

  scenario 'visitor attempts to subscribe and creates github user' do
    attempt_to_subscribe

    expect_to_be_on_checkout_page
    click_link 'with GitHub'

    expect_to_be_on_checkout_page

    expect(page).to have_no_field 'Password'

    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
  end

  scenario "visitor attempts to subscribe, signs in with github, but is already subscribed" do
    create(:user, :with_subscription, :with_github_auth)

    attempt_to_subscribe
    click_link "Already have an account? Sign in"
    click_on "Sign in with GitHub"

    expect(current_path).to eq edit_subscription_path
    expect(page).to have_content I18n.t("checkout.flashes.already_subscribed")
  end

  scenario "visitor attempts to subscribe with existing github username" do
    existing_user = create(:user, :with_github_auth)

    attempt_to_subscribe
    fill_out_account_creation_form_as existing_user
    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_checkouts_page
    expect_error_on_github_username_field
  end

  def expect_error_on_github_username_field
    expect(github_username_field[:class]).to include("error")
  end

  def expect_to_be_on_checkout_page
    expect(current_url).to eq new_checkout_url(@plan)
  end

  def expect_to_see_required(field)
    expect(page).to have_css("#checkout_#{field}_input abbr[title=required]")
  end

  def expect_to_see_email_error(text = "can't be blank")
    expect(page).to have_css(
      '#checkout_email_input.error p.inline-errors',
      text: text
    )
  end

  def expect_to_see_password_error
    expect(page).to have_css(
      '#checkout_password_input.error p.inline-errors',
      text: "can't be blank"
    )
  end

  def create_plan
    @plan = create(:plan, :featured)
  end

  def attempt_to_subscribe
    visit new_checkout_path(@plan)
  end

  def github_username_field
    find("#checkout_github_username_input")
  end
end
