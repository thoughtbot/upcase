require "rails_helper"

RSpec.feature "Users signs out" do
  scenario "from account page" do
    visit my_account_path(as: create(:user))
    click_link "Sign out"

    expect(current_path).to eq sign_in_path
  end
end
