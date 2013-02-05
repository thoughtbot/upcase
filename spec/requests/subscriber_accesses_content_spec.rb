require 'spec_helper'

feature 'Subscriber accesses content' do
  scenario 'views listing of all products' do
    create_all_product_types
    sign_in_as_user_with_subscription

    expect(page).to have_content I18n.t('shared.online_workshops')
    expect(page).to have_content I18n.t('shared.books')
    expect(page).to have_content I18n.t('shared.videos')

    expect(page).to_not have_content I18n.t('shared.subscription_call_to_action')
  end

  scenario 'accesses a product detail page' do
    video_product = create(:video_product)
    sign_in_as_user_with_subscription
    click_link video_product.name

    expect(page).to have_content I18n.t('products.show.free_to_subscribers')
    expect(page).to_not have_content video_product.individual_price
    expect(page).to_not have_content I18n.t('products.show.purchase_for_company')
  end

  def sign_in_as_user_with_subscription
    @current_user = create(:user, :with_subscription)
    visit products_path(as: @current_user)
  end

  def create_all_product_types
    create(:video_product)
    create(:book_product)
    create(:workshop_product)
    create(:subscribeable_product)
  end
end
