require 'spec_helper'

feature 'Account Settings' do
  scenario 'user views subscription' do
    user = create(:subscriber)

    visit edit_my_account_path(as: user)

    expect_to_see_my_subscription
  end

  scenario 'user views paid purchases' do
    user = create(:user)
    create_list(:paid_purchase, 4, user: user, created_at: 6.minutes.ago)
    purchase_two = create(:paid_purchase, user: user, created_at: 5.minutes.ago)
    purchase_one = create(:paid_purchase, user: user, created_at: 1.minutes.ago)

    visit edit_my_account_path(as: user)

    expect_to_see_my_paid_purchases(user)
    expect(purchase_one.purchaseable_name).
      to appear_before(purchase_two.purchaseable_name)
  end

  scenario 'user with no purchases' do
    user = create(:user)

    visit edit_my_account_path(as: user)

    expect(page).not_to have_content 'Your purchases'
  end

  scenario 'user with only unpaid purchases' do
    user = create(:user)
    create_list(:unpaid_purchase, 3, user: user)

    visit edit_my_account_path(as: user)

    expect(page).not_to have_content 'Your purchases'
  end

  scenario 'user with paid and unpaid purchases' do
    user = create(:user)
    book = create(:book, name: 'A Great Book')
    screencast = create(:screencast, name: 'A Great Video')
    create(:paid_purchase, purchaseable: book, user: user)
    create(:unpaid_purchase, purchaseable: screencast, user: user)

    visit edit_my_account_path(as: user)

    expect(page).to have_content book.name
    expect(page).not_to have_content screencast.name
  end

  scenario 'user edits account information' do
    user = create(:user, name: 'Test User')

    visit edit_my_account_path(as: user)

    fill_in 'Name', with: 'Change Name'
    click_button 'Update account'

    visit edit_my_account_path(as: user)

    expect(field_labeled('Name').value).to eq 'Change Name'
  end

  private 

  def expect_to_see_my_subscription
    expect(page).to have_css('ol.subscription li')
  end

  def expect_to_see_my_paid_purchases(user)
    expect(page).to have_css(
      'ol.purchases li',
      count: [user.paid_purchases.count, 5].min
    )
  end
end
