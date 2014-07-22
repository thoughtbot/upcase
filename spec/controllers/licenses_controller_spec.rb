require 'spec_helper'

describe LicensesController do
  describe "#create without being signed in" do
    it "redirects to sign in page" do
      workshop = build_stubbed(:workshop)

      post :create, workshop_id: workshop.id

      should deny_access
    end
  end

  describe "#create without being a subscriber" do
    it "redirect to the sign in page" do
      workshop = build_stubbed(:workshop)
      user = create(:user)
      sign_in_as user

      post :create, workshop_id: workshop.id

      should deny_access
    end
  end

  describe "#index" do
    it "assigns paid licenses belonging to the current user" do
      user = create(:user)
      license_two = create(:license, user: user, created_at: 5.minute.ago)
      license_one = create(:license, user: user, created_at: 1.minute.ago)
      create(:license)
      stub_current_user_with(user)

      get :index

      expect(assigns(:licenses)).to eq([license_one, license_two])
    end
  end
end
