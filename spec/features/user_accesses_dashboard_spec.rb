require 'spec_helper'

feature 'User without subscription' do
  scenario 'accesses dashboard' do
    visit dashboard_path(as: create(:user))

    expect(page).to have_content("Read our eBooks")
  end
end
