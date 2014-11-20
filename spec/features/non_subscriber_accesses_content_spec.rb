require "rails_helper"

feature "User without subscription" do
  scenario "accesses the practice page" do
    visit practice_path(as: create(:user))

    expect(page).to have_content("Upcase source code")
  end
end
