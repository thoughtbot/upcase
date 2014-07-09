require 'spec_helper'

feature 'User cancels a subscription' do
  scenario 'successfully unsubscribes without a refund' do
    create(:plan, name: 'Prime')
    create(:basic_plan)
    create(:workshop, name: 'A Cool Workshop')

    sign_in_as_user_with_subscription

    expect(@current_user).to have_active_subscription

    visit my_account_path
    click_link I18n.t('subscriptions.cancel')

    expect_to_see_alternate_offer

    click_button I18n.t('subscriptions.confirm_cancel_reject_deal')

    expect(page).to have_content I18n.t('subscriptions.flashes.cancel.success')
  end

  def expect_to_see_alternate_offer
    expect(page).to have_content 'make sure you know about the option to switch'
  end
end
