require 'spec_helper'

feature 'User cancels a subscription', js: true do
  scenario 'successfully unsubscribes' do
    create(:plan, sku: 'prime', name: 'Prime')
    create(:basic_plan)
    create(:workshop, name: 'A Cool Workshop')

    sign_in_as_user_with_subscription
    @current_user.should have_active_subscription
    visit products_path
    expect(find('.header-container')).not_to have_content('Prime Membership')
    click_workshop_detail_link
    expect(page).not_to have_link('Subscribe to Prime')

    ActionMailer::Base.deliveries.clear

    visit my_account_path
    click_link I18n.t('subscriptions.cancel')

    expect_to_see_alternate_offer

    click_button I18n.t('subscriptions.confirm_cancel_reject_deal')

    expect(page).to have_no_link I18n.t('subscriptions.cancel')
    expect(page).to have_content "Scheduled for cancellation on February 19, 2013"
    expect(page).to have_content I18n.t('subscriptions.flashes.cancel.success')
  end

  def click_workshop_detail_link
    click_link 'View Details'
  end

  def expect_to_see_alternate_offer
    expect(page).to have_content 'make sure you know about the option to switch'
  end
end
