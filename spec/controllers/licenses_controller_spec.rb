require 'spec_helper'

describe LicensesController, type: :controller do
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
end
