require 'spec_helper'

feature 'User cancels a subscription' do
  scenario 'successfully unsubscribes' do
    online_section = create(:online_section)
    ActionMailer::Base.deliveries.clear

    sign_in_as_user_with_subscription
    cancel_subscription
    visit products_path
    click_link online_section.workshop.name

    expect(page).to_not have_content I18n.t('workshops.show.free_to_subscribers')
    expect(ActionMailer::Base.deliveries).to have(1).item
    @current_user.should_not have_active_subscription
  end

  def cancel_subscription
    visit my_account_path
    click_link I18n.t('subscriptions.cancel')
  end
end
