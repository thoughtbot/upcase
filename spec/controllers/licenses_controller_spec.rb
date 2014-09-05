require "rails_helper"

describe LicensesController do
  describe "#create without being signed in" do
    it "redirects to sign in page" do
      video_tutorial = build_stubbed(:video_tutorial)

      post :create, video_tutorial_id: video_tutorial.id

      should deny_access
    end
  end

  describe "#create without being a subscriber" do
    it "redirect to the sign in page" do
      video_tutorial = build_stubbed(:video_tutorial)
      user = create(:user)
      sign_in_as user

      post :create, video_tutorial_id: video_tutorial.id

      should deny_access
    end
  end
end
