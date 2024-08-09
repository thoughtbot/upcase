require "rails_helper"

feature "Account Settings" do
  scenario "user edits account information" do
    user = create(:user, name: "Test User")

    visit edit_my_account_path(as: user)

    fill_in "Name", with: "Change Name"
    click_button "Update account"

    expect(page).to have_content I18n.t("users.flashes.update.success")

    visit edit_my_account_path(as: user)

    expect(field_value_from_name("Name")).to eq "Change Name"
  end

  private

  def field_value_from_name(name)
    find_field(name).value
  end
end
