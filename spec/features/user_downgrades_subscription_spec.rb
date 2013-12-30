require 'spec_helper'

feature 'User downgrades subscription', js: true do
  scenario 'successfully downgrades and then cancels' do
    prime = create(:plan, sku: 'prime', name: 'Prime')
    basic_plan = create(:basic_plan)
    section = create(:online_section)

    sign_in_as_user_with_subscription
    @current_user.should have_active_subscription
    visit products_path
    expect(find('.header-container')).not_to have_content('Prime Membership')
    expect(page).not_to have_link('Subscribe to Prime')

    ActionMailer::Base.deliveries.clear

    visit my_account_path
    click_link I18n.t('subscriptions.cancel')
    click_link 'Change to'

    expect(page).to have_link I18n.t('subscriptions.cancel')
    expect(page).to have_no_content "Scheduled for cancellation"
    @current_user.reload
    expect(@current_user.subscription.plan).to eq basic_plan

    visit workshop_path(section.workshop)

    expect(page).not_to have_css('.free-with-prime')

    visit products_path

    expect(page).not_to have_css('section.mentor h3', text: 'Your Mentor')

    visit my_account_path
    click_link I18n.t('subscriptions.cancel')

    expect(page).not_to have_content 'deal'
    expect(page).not_to have_content 'Change to'

    click_button I18n.t('subscriptions.confirm_cancel')

    expect(page).to have_content "Scheduled for cancellation on February 19, 2013"
    expect(page).to have_content I18n.t('subscriptions.flashes.cancel.success')
  end
end
