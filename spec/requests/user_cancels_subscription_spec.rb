require 'spec_helper'

feature 'User cancels a subscription', js: true do
  scenario 'successfully unsubscribes' do
    prime = create(:subscribeable_product, sku: 'prime', name: 'Prime')
    create(:online_section,
      workshop: create(:workshop, name: 'A Cool Workshop')
    )

    sign_in_as_user_with_subscription
    create(:purchase, :free, user: @current_user, purchaseable: prime)
    @current_user.should have_active_subscription
    visit products_path
    expect(find('.header-container')).not_to have_content('Prime Membership')
    click_link 'A Cool Workshop'
    expect(page).to have_content I18n.t('workshops.show.free_to_subscribers')
    expect(page).not_to have_link('Subscribe to Prime')

    ActionMailer::Base.deliveries.clear

    visit my_account_path
    click_link I18n.t('subscriptions.cancel')
    page.driver.browser.switch_to.alert.accept
    # the have_no_link implicitly waits for the request to come back
    expect(page).to have_no_link I18n.t('subscriptions.cancel')
    expect(ActionMailer::Base.deliveries.size).to be 1
    @current_user.reload
    @current_user.should_not have_active_subscription
    visit products_path
    expect(find('.header-container')).to have_content('Prime Membership')
    click_link 'A Cool Workshop'
    expect(page).not_to have_content I18n.t('workshops.show.free_to_subscribers')
    click_link 'Subscribe to Prime'
    expect(page).to have_content('Thank you for purchasing Prime')
    expect(page).to have_content('You stopped subscribing to Prime')
  end
end
