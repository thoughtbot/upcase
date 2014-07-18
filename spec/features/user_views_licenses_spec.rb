require 'spec_helper'

feature 'User views licenses' do
  include ActiveSupport::NumberHelper

  scenario 'with licenses' do
    user = create(:user)
    license_one = create(:license, user: user)
    license_two = create(:license, user: user)

    visit edit_my_account_path(as: user)

    click_link I18n.t('account.view_licenses')

    expect(page).to have_content(license_one.licenseable_name)
    expect(page).to have_content(license_two.licenseable_name)
  end
end
