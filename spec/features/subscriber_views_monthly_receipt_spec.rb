require "rails_helper"

feature 'Subscriber views subscription invoices' do
  scenario 'Subscriber views a listing of all invoices' do
    sign_in_as_user_with_subscription
    @current_user.stripe_customer_id = FakeStripe::CUSTOMER_ID
    @current_user.save!

    visit my_account_path
    click_link 'View all invoices'

    expect(page).to have_css('.number', text: '130521')
    expect(page).to have_css('.date', text: '05/21/13')
    expect(page).to have_css('.total', text: '$79.00')
    expect(page).to have_css('.balance', text: '$0.00')

    click_link '130521'

    expect(page).to have_content('Invoice 130521')
  end

  scenario 'Subscriber can view a subscription invoice' do
    sign_in_as_user_with_subscription
    create(:checkout, user: @current_user)
    @current_user.stripe_customer_id = FakeStripe::CUSTOMER_ID
    @current_user.organization = 'Sprockets, LLC'
    @current_user.address1 = '1 Street Way'
    @current_user.address2 = 'Suite 3'
    @current_user.city = 'Austin'
    @current_user.state = 'TX'
    @current_user.zip_code = '00000'
    @current_user.country = 'USA'
    @current_user.save!

    visit subscriber_invoice_path(FakeStripe::INVOICE_ID)

    expect(page).to have_content('Invoice 130521')
    expect(page).to have_content('Date 05/21/13')
    expect(page).to have_css(
      '.line-item',
      text: I18n.t("shared.subscription.name")
    )
    expect(page).to have_css('.line-item', text: '$99.00 USD')
    expect(page).to have_css('.subtotal', text: '$99.00 USD')
    expect(page).to have_css('.discount', text: 'Discount: railsconf')
    expect(page).to have_css('.discount', text: '- $20.00 USD')
    expect(page).to have_css('.total', text: '$79.00 USD')
    expect(page).to have_content('Invoice lookup: in_1s4JSgbcUaElzU')

    expect(page).to have_content(@current_user.organization)
    expect(page).to have_content(@current_user.address1)
    expect(page).to have_content(@current_user.address2)
    expect(page).to have_content(@current_user.city)
    expect(page).to have_content(@current_user.state)
    expect(page).to have_content(@current_user.zip_code)
    expect(page).to have_content(@current_user.country)
  end

  scenario 'Subscriber views a cancelation or down/upgrade invoice' do
    sign_in_as_user_with_subscription
    @current_user.stripe_customer_id = FakeStripe::CUSTOMER_ID
    @current_user.organization = 'Sprockets, LLC'
    @current_user.address1 = '1 Street Way'
    @current_user.address2 = 'Suite 3'
    @current_user.city = 'Austin'
    @current_user.state = 'TX'
    @current_user.zip_code = '00000'
    @current_user.country = 'USA'
    @current_user.save!

    visit subscriber_invoice_path('in_3lNBWqTVMT9sFb')

    expect(page).to have_content('Invoice 130521')
    expect(page).to have_content('Date 05/21/13')
    expect(page).to have_css(
      '.line-item',
      text: 'Remaining time on Upcase VideoTutorials after 22 Feb 2014'
    )
    expect(page).to have_css('.line-item', text: '$98.76 USD')
    expect(page).to have_css(
      '.line-item',
      text: 'Unused time on Upcase Basic after 22 Feb 2014'
    )
    expect(page).to have_css('.line-item', text: '-$28.93 USD')
    expect(page).to have_css('.subtotal', text: '$69.83 USD')
    expect(page).to have_css('.total', text: '$69.83 USD')
    expect(page).to have_content('Invoice lookup: in_3lNBWqTVMT9sFb')

    expect(page).to have_content(@current_user.organization)
    expect(page).to have_content(@current_user.address1)
    expect(page).to have_content(@current_user.address2)
    expect(page).to have_content(@current_user.city)
    expect(page).to have_content(@current_user.state)
    expect(page).to have_content(@current_user.zip_code)
    expect(page).to have_content(@current_user.country)
  end
end
