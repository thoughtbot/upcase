require 'spec_helper'

feature 'Visitor is asked to create a user before subscription' do

  VALID_SANDBOX_CREDIT_CARD_NUMBER = '4111111111111111'

  background do
    create_subscribeable_product
    sign_out
  end

  scenario 'visitor attempts to subscribe and creates email/password user' do
    attempt_to_subscribe

    expect_to_be_on_subscription_purchase_page
    expect_to_see_password_required

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect_to_see_password_error

    user = build(:user)
    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'GitHub username', with: 'cpytel'
    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to eq products_path
    expect(page).to have_content(I18n.t('purchase.flashes.success', name: subscription_product.name))
  end

  scenario 'visitor attempts to subscribe and creates github user' do
    attempt_to_subscribe

    expect_to_be_on_subscription_purchase_page
    click_link 'with GitHub'

    expect_to_be_on_subscription_purchase_page

    expect(page).not_to have_content 'Password'

    fill_out_credit_card_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to eq products_path
    expect(page).to have_content(I18n.t('purchase.flashes.success', name: subscription_product.name))
  end


  def expect_to_be_on_subscription_purchase_page
    expect(current_url).to eq new_product_purchase_url(subscription_product, variant: 'individual')
  end

  def expect_to_see_password_required
    expect(page).to have_css('#purchase_password_input abbr[title=required]')
  end

  def expect_to_see_password_error
    expect(page).to have_css(
      '#purchase_password_input.error p.inline-errors',
      text: "can't be blank"
    )
  end

  def create_subscribeable_product
    @subscription_product = create(:subscribeable_product)
  end

  def sign_out
    visit root_path(as: nil)
  end

  def attempt_to_subscribe
    visit prime_path
    click_landing_page_call_to_action
  end

  def current_user
    @current_user
  end

  def subscription_product
    @subscription_product
  end
end
