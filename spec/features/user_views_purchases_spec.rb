require 'spec_helper'

feature 'User views purchases' do
  include ActiveSupport::NumberHelper

  scenario 'with paid purchases' do
    user = create(:user)
    purchase_one = create(:paid_purchase, user: user)
    purchase_two = create(:paid_purchase, user: user)

    visit edit_my_account_path(as: user)

    click_link I18n.t('account.view_purchases')

    expect(page).to have_content(purchase_one.purchaseable_name)
    expect(page).to have_content(purchase_two.purchaseable_name)
  end
end
