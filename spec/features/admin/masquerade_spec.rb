require "rails_helper"

feature "Masquerade" do
  scenario "admin masquerades as a user" do
    email = "foo@bar.com"
    user = create(:user, email: email)
    admin = create(:user, admin: true)

    sign_in_as(admin)
    visit admin_users_path
    click_on("Masquerade")

    expect(page).to have_flash("Now masquerading as #{email}")
  end

  def have_flash(text)
    have_css(".flash", text: text)
  end
end
