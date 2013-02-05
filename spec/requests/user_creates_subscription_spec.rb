require 'spec_helper'

feature 'User creates a subscription' do
  VALID_SANDBOX_CREDIT_CARD_NUMBER = '4111111111111111'

  background do
    create_subscribeable_product
  end

  scenario 'creates a Stripe subscription with a valid credit card' do
    sign_in
    subscribe_with_valid_credit_card
    expect(current_user).to have_active_subscription
    expect(current_path).to eq products_path
  end

  scenario 'does not create a Stripe subscription with an invalid credit card' do
    sign_in
    subscribe_with_invalid_credit_card
    expect(current_user).not_to have_active_subscription
  end

  def create_subscribeable_product
    create(:subscribeable_product)
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
    click_link 'VIEW ALL'
    click_link 'Subscribe'

    within '.individual-purchase' do
      find('.license-button').click
    end

    fill_out_credit_card_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER
  end

  def subscribe_with_invalid_credit_card
    click_link 'VIEW ALL'
    click_link 'Subscribe'

    within '.individual-purchase' do
      find('.license-button').click
    end

    FakeStripe.failure = true
    fill_out_credit_card_form_with 'bad cc number'
  end

  def current_user
    @current_user
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
