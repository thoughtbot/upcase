require "rails_helper"

describe AnnualBillingsController do
  describe "#new without being signed in" do
    it "redirects to the sign in page" do
      get :new

      expect(response).to redirect_to sign_in_path
    end
  end

  describe "#create without being signed in" do
    it "redirects to the sign in page" do
      get :create

      expect(response).to redirect_to sign_in_path
    end
  end
end
