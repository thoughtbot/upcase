require "rails_helper"

describe AttemptsController do
  describe "#create" do
    it "redirects if not logged in" do
      post :create, question_id: 1

      expect(response).to redirect_to(sign_in_path)
    end
  end
end
