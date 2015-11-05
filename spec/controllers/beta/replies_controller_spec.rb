require "rails_helper"

describe Beta::RepliesController do
  describe "#create" do
    context "signed in when accepting the offer" do
      it "accepts and redirects to practice" do
        offer = stub_offer
        user = sign_in
        post_create offer: offer, accepted: true

        expect(response).to redirect_to(practice_url)
        expect(offer).to have_received_reply(user: user, accepted: true)
      end
    end

    context "signed in when declining the offer" do
      it "declines and redirects to practice" do
        offer = stub_offer
        user = sign_in
        post_create offer: offer, accepted: false

        expect(response).to redirect_to(practice_url)
        expect(offer).to have_received_reply(user: user, accepted: false)
      end
    end

    context "signed out" do
      it "redirects to sign in" do
        sign_out
        post_create

        expect(response).to redirect_to(sign_in_url)
      end
    end

    def stub_offer
      build_stubbed(:beta_offer).tap do |offer|
        allow(Beta::Offer).
          to receive(:find).
          with(offer.to_param).
          and_return(offer)
        allow(offer).to receive(:reply)
      end
    end

    def post_create(offer: stub_offer, accepted: false)
      post :create, offer_id: offer.to_param, accepted: accepted.to_s
    end

    def have_received_reply(user:, accepted:)
      have_received(:reply).with(user: user, accepted: accepted)
    end
  end
end
