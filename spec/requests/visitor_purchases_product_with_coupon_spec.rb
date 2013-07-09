require 'spec_helper'

feature 'Using coupons' do
  include StripeHelpers
  include PurchaseHelpers

  scenario 'Visitor purchases with a valid coupon', js: true, driver: :poltergeist do
    product = create(:video_product)
    create(:coupon, code: 'CODE', discount_type: 'percentage', amount: 10)

    visit product_path(product)
    click_purchase_link
    click_link 'Have a coupon code?'
    expect(find('.coupon')).to be_visible
    fill_in 'Code', with: 'CODE'
    click_button 'Apply Coupon'

    expect_submit_button_to_contain('10% off')
    expect(find('.coupon')).to_not be_visible

    pay_using_stripe

    expect_to_have_purchased(product)
  end

  scenario 'Visior purchases with a 100%-off coupon', js: true, driver: :poltergeist do
    product = create(:video_product)
    create(:coupon, code: 'CODE', discount_type: 'percentage', amount: 100)

    visit product_path(product)
    click_purchase_link
    click_link 'Have a coupon code?'
    fill_in 'Code', with: 'CODE'
    click_button 'Apply Coupon'

    expect_payment_options_to_be_hidden

    fill_in 'Name', with: 'Eugene'
    fill_in 'Email', with: 'mr.the.plague@example.com'
    click_button 'Submit Payment'

    expect_to_have_purchased(product)
  end

  def expect_payment_options_to_be_hidden
    page.should have_no_css('#billing-information')
  end

end
