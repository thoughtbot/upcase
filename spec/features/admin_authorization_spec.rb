require "rails_helper"

feature "Admin authorization" do
  scenario "admin accesses dashboard" do
    admin = create(:user, admin: true)

    sign_in_as(admin)
    visit admin_root_path

    expect(page).to have_admin_users_header
  end

  scenario "non-admin cannot access dashboard" do
    non_admin = create(:user, admin: false)

    sign_in_as(non_admin)
    visit admin_root_path

    expect(page).not_to have_admin_users_header
  end

  def have_admin_users_header
    have_css("h1", text: "Users")
  end
end
