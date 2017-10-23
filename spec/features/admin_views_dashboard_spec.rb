require "rails_helper"

feature "Admin views the dashboard" do
  scenario "successfully" do
    visit admin_path(as: create(:admin))

    expect(page).to have_content("Administration Dashboard")
  end
end
