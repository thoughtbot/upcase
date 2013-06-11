require 'spec_helper'

feature 'Purchasing a product' do
  include StripeHelpers
  include PurchaseHelpers

  scenario 'Visitor signs up while purchasing a product' do
    product = create(:video_product)
    visit product_path(product)
    click_purchase_link
    click_link 'Sign in.'
    click_link 'Sign up'

    fill_in 'user_first_name', with: 'Ben'
    fill_in 'user_last_name', with: 'Orenstein'
    fill_in 'Email', with: 'ben@thoughtbot.com'
    fill_in 'Password', with: 'password'
    click_button 'Create an account'

    expect(page).to have_css('form#new_purchase')
    expect(field_labeled('Email').value).to eq 'ben@thoughtbot.com'
    expect(field_labeled('Name').value).to eq 'Ben Orenstein'
    expect(page).to have_content 'Sign out'
  end

  scenario 'Visitor purchases product with paypal', js: true, driver: :poltergeist do
    product = create(:video_product)
    visit product_path(product)
    click_purchase_link
    pay_using_paypal

    expect_to_have_purchased(product)
  end

  scenario 'Visitor purchases a product with stripe', js: true, driver: :poltergeist do
    product = create(:video_product)
    visit product_path(product)
    click_purchase_link
    pay_using_stripe

    expect_to_have_purchased(product)
  end

  scenario 'Visitor tries to pay with Stripe but gets a failure', js: true, driver: :poltergeist do
    product = create(:video_product)
    stub_stripe_to_fail
    visit product_path(product)
    click_purchase_link
    pay_using_stripe

    expect(page).to have_content 'There was a problem processing your credit card'
  end

  scenario 'User purchases a github book with a reader', js: true, driver: :poltergeist do
    product = create(:github_book_product)
    user = create(:user)
    visit product_path(product, as: user)
    click_purchase_link
    fill_in "github_username_1", with: "cpytel"
    pay_using_stripe

    expect_to_have_purchased(product)

    visit my_account_path
    expect(find_field("Github username").value).to eq 'cpytel'
  end

  scenario 'User attempts to purchase a github book withou specifying a reader', js: true, driver: :poltergeist do
    product = create(:github_book_product)
    user = create(:user)
    visit product_path(product, as: user)
    click_purchase_link
    click_button 'Submit Payment'
    expect(page).to have_css("li.error input#github_username_1")
  end

  def stub_stripe_to_fail
    FakeStripe.failure = true
  end

  def pay_using_paypal
    uri = URI.parse(current_url)
    Purchase.host = "#{uri.host}:#{uri.port}"
    choose 'purchase_payment_method_paypal'
    fill_in_name_and_email
    click_button 'Proceed to Checkout'
    click_button 'Pay using Paypal'
  end
end
