require 'spec_helper'

feature 'Visitor is asked to create a user before subscription' do
  background do
    create_subscribeable_product
    sign_out
  end

  scenario 'visitor attempts to subscribe' do
    attempt_to_subscribe

    expect_to_be_on_subscription_landing_page

    sign_up

    expect_to_be_on_subscription_purchase_page
  end

  def expect_to_be_on_subscription_landing_page
    expect(current_url).to eq sign_up_url
    expect(page).to have_content(I18n.t('shared.subscriptions.user_required'))
  end

  def expect_to_be_on_subscription_purchase_page
    expect(current_url).to eq new_product_purchase_url(subscription_product, variant: 'individual')
  end

  def create_subscribeable_product
    @subscription_product = create(:subscribeable_product)
  end

  def create_product_with_video
    video_product = create :video_product
    create :video, watchable: video_product
    video_product
  end

  def sign_out
    visit root_path(as: nil)
  end

  def attempt_to_subscribe
    visit products_path
    click_link I18n.t('shared.subscription_call_to_action')
    click_link I18n.t('products.show.purchase_subscription')
  end

  def current_user
    @current_user
  end

  def subscription_product
    @subscription_product
  end

  def sign_up
    user = build(:user)
    fill_in 'First name', with: user.first_name
    fill_in 'Last name', with: user.last_name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign up'
  end
end
