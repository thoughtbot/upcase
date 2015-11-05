require "rails_helper"

describe Beta::RepliesController do
  describe "#create" do
    context "signed in" do
      it "redirects to practice" do
        sign_in
        post_create

        expect(response).to redirect_to(practice_url)
      end
    end

    context "signed out" do
      it "redirects to sign in" do
        sign_out
        post_create

        expect(response).to redirect_to(sign_in_url)
      end
    end

    def post_create
      offer = build_stubbed(:beta_offer)
      allow(Beta::Offer).
        to receive(:find).
        with(offer.to_param).
        and_return(offer)
      allow(Beta::Reply).to receive(:create!)

      post :create, offer_id: offer.to_param
    end
  end
end
