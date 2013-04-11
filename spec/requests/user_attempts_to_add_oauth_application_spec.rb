require 'spec_helper'

feature 'User attempts to add OAuth application' do
  scenario 'as non-admin' do
    user = create(:user)
    visit oauth_applications_path(as: user)
    page.current_url.should eq sign_in_url
  end

  scenario 'when not authenticated' do
    visit oauth_applications_path
    page.current_url.should eq sign_in_url
  end
end
