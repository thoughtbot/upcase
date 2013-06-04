require 'spec_helper'

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
    subscription_purchase = create(:subscription_purchase, user: @current_user)
    @current_user.stripe_customer_id = FakeStripe::CUSTOMER_ID
    @current_user.organization = 'Sprockets, LLC'
    @current_user.address1 = '1 Street Way'
    @current_user.address2 = 'Suite 3'
    @current_user.city = 'Austin'
    @current_user.state = 'TX'
    @current_user.zip_code = '00000'
    @current_user.country = 'USA'
    @current_user.save!

    visit subscriber_invoice_path("in_1s4JSgbcUaElzU")

    expect(page).to have_content('Invoice 130521')
    expect(page).to have_content('Date 05/21/13')
    expect(page).to have_css('.subscription', text: 'Subscription to Prime')
    expect(page).to have_css('.subscription', text: '$99.00 USD')
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

  scenario "a subscriber can't view another user's invoice" do
    sign_in_as_user_with_subscription
    subscription_purchase = create(:subscription_purchase, user: @current_user)
    @current_user.stripe_customer_id = "cus_NOMATCH"
    @current_user.save!

    expect do
      visit subscriber_invoice_path("in_1s4JSgbcUaElzU")
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end
