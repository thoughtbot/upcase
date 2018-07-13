require "rails_helper"

feature "Admin views the dashboard" do
  scenario "successfully" do
    visit rails_admin_path(as: create(:admin))

    expect(page).to have_content("Site Administration")
  end
end
