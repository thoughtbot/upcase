require "rails_helper"

RSpec.describe "new_admin_deck_path" do
  context "if user is not an admin" do
    it "is not found" do
      get new_admin_deck_path(as: create(:user, admin: false))

      expect(response).to have_http_status(:not_found)
    end
  end

  context "if user is an admin" do
    it "is not found" do
      get new_admin_deck_path(as: create(:user, admin: true))

      expect(response).to have_http_status(:ok)
    end
  end
end
