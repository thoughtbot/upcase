require "rails_helper"

describe QuizzesController do
  describe "#index" do
    context "when no user is signed in" do
      it "redirects to the sign in page" do
        get :index

        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe "#show" do
    context "when no user is signed in" do
      it "redirects to the sign in page" do
        get :show, id: 1

        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
