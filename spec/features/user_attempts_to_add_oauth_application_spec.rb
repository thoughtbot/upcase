require "rails_helper"

feature 'User attempts to add OAuth application' do
  scenario 'as non-admin' do
    user = create(:user)
    visit oauth_applications_path(as: user)
    expect(page.current_url).to eq practice_url
  end

  scenario 'when not authenticated' do
    visit oauth_applications_path
    expect(page.current_url).to eq sign_in_url
  end
end
