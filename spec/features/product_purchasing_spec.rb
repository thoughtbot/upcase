require 'spec_helper'

feature 'Purchasing a product' do
  include StripeHelpers
  include PurchaseHelpers

  scenario 'Visitor signs up while purchasing a product' do
    AssociatePreviousPurchases.stubs(:create_associations_for)
    product = create(:screencast)
    visit product_path(product)
    click_purchase_link_for(product)
    click_link 'Already have an account? Sign in'
    click_link 'Sign up'

    fill_in 'user_name', with: 'Ben Orenstein'
    fill_in 'Email', with: 'ben@thoughtbot.com'
    fill_in 'Password', with: 'password'
    click_button 'Create an account'

    previous_purchases_are_associated_with('ben@thoughtbot.com')
    expect(page).to have_css('form#new_purchase')
    expect(field_labeled('Email').value).to eq 'ben@thoughtbot.com'
    expect(field_labeled('Name').value).to eq 'Ben Orenstein'
    expect(page).to have_content 'Sign out'
  end

  scenario 'Visitor signs in with GitHub while purchasing a product' do
    create(:user, :with_github)
    product = create(:screencast)

    visit product_path(product)
    click_purchase_link_for(product)
    click_link 'Already have an account? Sign in'
    click_on 'Sign in with GitHub'

    expect(page).to have_css('form#new_purchase')
    expect(field_labeled('Email').value).not_to be_blank
    expect(field_labeled('Name').value).not_to be_blank
    expect(page).to have_content 'Sign out'
  end

  scenario 'Visitor signs in with email and password while purchasing a product' do
    user = create(:user, password: 'password')
    product = create(:screencast)

    visit product_path(product)
    click_purchase_link_for(product)
    click_link 'Already have an account? Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    expect(page).to have_css('form#new_purchase')
    expect(field_labeled('Email').value).to eq user.email
    expect(field_labeled('Name').value).to eq user.name
    expect(page).to have_content 'Sign out'
  end

  scenario 'Visitor purchases product with paypal', js: true do
    product = create(:screencast)
    visit product_path(product)
    click_purchase_link_for(product)
    pay_using_paypal

    expect_to_have_purchased(product)
  end

  scenario 'Visitor purchases a product with stripe', js: true do
    product = create(:screencast)
    visit product_path(product)
    click_purchase_link_for(product)
    pay_using_stripe

    expect_to_have_purchased(product)
  end

  scenario 'Visitor tries to pay with Stripe but gets a failure', js: true do
    product = create(:screencast)
    stub_stripe_to_fail
    visit product_path(product)
    click_purchase_link_for(product)
    pay_using_stripe

    expect(page).to have_content 'There was a problem processing your credit card'
  end

  scenario 'User purchases a github book with a reader', js: true do
    product = create(:book, :github)
    user = create(:user)
    visit product_path(product, as: user)
    click_purchase_link_for(product)
    fill_in 'github_username_1', with: 'cpytel'
    pay_using_stripe

    expect_to_have_purchased(product)

    visit my_account_path
    expect(find_field('Github username').value).to eq 'cpytel'
  end

  scenario 'User purchases a product with an existing credit card', js: true do
    product = create(:screencast)
    user = create(:user, stripe_customer_id: 'test')
    stub_existing_card_for_user(user)

    visit product_path(product, as: user)
    click_purchase_link_for(product)
    pay_using_stripe_with_existing_card

    expect_to_have_purchased(product)
  end

  scenario 'User with a github username has it already supplied on purchasing' do
    product = create(:book, :github)
    user = create(:user, github_username: 'thoughtbot')

    visit product_path(product, as: user)
    click_purchase_link_for(product)

    expect(find_field('Github username').value).to eq 'thoughtbot'
  end

  scenario 'User attempts to purchase a github book without specifying a reader', js: true do
    product = create(:book, :github)
    user = create(:user)
    visit product_path(product, as: user)
    click_purchase_link_for(product)
    click_button 'Submit Payment'
    expect(page).to have_css('li.error input#github_username_1')
  end

  def previous_purchases_are_associated_with(email)
    user = User.find_by(email: email)
    expect(AssociatePreviousPurchases).to have_received(:create_associations_for).with(user)
  end

  def stub_existing_card_for_user(user)
    user.update_column(:stripe_customer_id, 'test')
    Stripe::Customer.stubs(:retrieve).returns(
      {'active_card' => {'last4' => '1234', 'type' => 'Visa'}}
    )
  end
end
