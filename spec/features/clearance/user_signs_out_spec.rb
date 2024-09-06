require "rails_helper"

feature "User signs out" do
  scenario "signs out" do
    signed_in_user

    sign_out

    expect(current_path).to eq(sign_in_path)
  end
end
