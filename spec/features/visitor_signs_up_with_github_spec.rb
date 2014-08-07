require "rails_helper"

feature 'Visitor creates an account' do
  scenario 'authorizing through GitHub' do
    visit sign_up_path
    click_link 'with GitHub'

    expect(current_path).to eq dashboard_path
  end
end
