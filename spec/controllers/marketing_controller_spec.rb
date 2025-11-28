require "rails_helper"

RSpec.describe MarketingController do
  context "the user is not logged in" do
    it "renders the content of /join, but stays on /" do
      get :show

      expect(response).to render_template("pages/landing")
    end
  end
end
