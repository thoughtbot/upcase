require 'spec_helper'

feature 'User creates a subscription' do
  VALID_SANDBOX_CREDIT_CARD_NUMBER = '4111111111111111'

  background do
    create_subscribeable_product
    sign_in
  end

  scenario 'creates a Stripe subscription with a valid credit card' do
    subscribe_with_valid_credit_card
    expect(current_user).to have_active_subscription
    expect(current_path).to eq products_path
    expect(page).to have_content(I18n.t('purchase.flashes.success', name: subscription_product.name))
  end

  scenario 'does not create a Stripe subscription with an invalid credit card' do
    subscribe_with_invalid_credit_card
    expect(current_user).not_to have_active_subscription
  end

  scenario 'does not see a group option' do
    visit_subscription_product_page
    expect(page).to_not have_content(I18n.t('products.show.purchase_for_company'))
  end

  scenario 'sees that the subscription is per month' do
    visit_subscription_product_page
    click_purchase_link

    expect(page).to have_content('per month')
  end

  scenario "user without github username sees github username input" do
    current_user.github_username = nil
    current_user.save!

    visit_subscription_product_page
    click_purchase_link

    expect(page).to have_content('GitHub username')
    expect(page).to have_css('input#reader_1')
  end

  scenario "user with github username doesn't see github username input" do
    current_user.github_username = 'cpyteltest'
    current_user.save!

    visit_subscription_product_page
    click_purchase_link

    expect(page).not_to have_content('GitHub username')
    expect(page).not_to have_css('input#reader_1')
  end

  def visit_subscription_product_page
    click_link 'VIEW ALL'
    click_link 'Subscribe'
  end

  def create_subscribeable_product
    @subscription_product = create(:subscribeable_product)
  end

  def create_product_with_video
    video_product = create :video_product
    create :video, watchable: video_product
    video_product
  end

  def sign_in
    @current_user = create(:user)
    visit root_path(as: @current_user)
  end

  def subscribe_with_valid_credit_card
    start_purchasing_subscription
    fill_out_credit_card_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER
  end

  def subscribe_with_invalid_credit_card
    start_purchasing_subscription
    FakeStripe.failure = true
    fill_out_credit_card_form_with 'bad cc number'
  end

  def start_purchasing_subscription
    visit_subscription_product_page
    click_purchase_link
  end

  def click_purchase_link
    within '.individual-purchase' do
      click_link I18n.t('products.show.purchase_subscription')
    end
  end

  def current_user
    @current_user
  end

  def subscription_product
    @subscription_product
  end

  def fill_out_credit_card_form_with(credit_card_number)
    credit_card_expires_on = Time.now.advance(years: 1)
    month_selection = credit_card_expires_on.strftime('%-m - %B')
    year_selection = credit_card_expires_on.strftime('%Y')

    fill_in 'Card Number', with: credit_card_number
    select month_selection, from: 'date[month]'
    select year_selection, from: 'date[year]'
    fill_in 'CVC', with: '333'
    click_button 'Submit Payment'
  end
end
