require "rails_helper"

describe VideoTutorialsController do
  context "show" do
    it "renders show_subscribed if user has access" do
      video_tutorial = create(:video_tutorial)
      user = create(:subscriber, :with_full_subscription)
      sign_in_as user

      get :show, id: video_tutorial

      expect(response).to render_template "show_subscribed"
    end

    it "renders show page if user has not access" do
      video_tutorial = create(:video_tutorial)
      user = create(:user)
      sign_in_as user

      get :show, id: video_tutorial

      expect(response).to render_template "show"
    end
  end
end
