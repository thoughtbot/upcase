require "rails_helper"

RSpec.describe ForumSessionsController do
  include StubCurrentUserHelper

  describe "#new" do
    context "when logged in as a user" do
      it "properly redirects to the forum" do
        user = create(:user)
        stub_current_user_with(user)
        discourse_sso = discourse_sso_stub
        allow(SingleSignOn).to receive(:parse).and_return(discourse_sso)

        get :new, params: {sso: "ssohash", sig: "sig"}

        expect(SingleSignOn).to have_received(:parse)
          .with(
            "sig=sig&sso=ssohash",
            ENV.fetch("DISCOURSE_SSO_SECRET")
          )
        expect(response).to redirect_to(
          discourse_sso.to_url(
            Forum.sso_url
          )
        )
        expect(discourse_sso).to have_received(:email=)
          .with(user.email)
        expect(discourse_sso).to have_received(:name=)
          .with(user.name)
        expect(discourse_sso).to have_received(:username=)
          .with(user.github_username)
        expect(discourse_sso).to have_received(:external_id=)
          .with(user.id)
        expect(discourse_sso).to have_received(:sso_secret=)
          .with(ENV.fetch("DISCOURSE_SSO_SECRET"))
      end
    end

    context "when logged in but not subscribed" do
      it "properly redirects to the forum" do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        discourse_sso = discourse_sso_stub
        allow(SingleSignOn).to receive(:parse).and_return(discourse_sso)

        get :new, params: {sso: "ssohash", sig: "sig"}

        expect(SingleSignOn).to have_received(:parse)
          .with(
            "sig=sig&sso=ssohash",
            ENV.fetch("DISCOURSE_SSO_SECRET")
          )
        expect(response).to redirect_to(
          discourse_sso.to_url(
            Forum.sso_url
          )
        )
        expect(discourse_sso).to have_received(:email=)
          .with(user.email)
        expect(discourse_sso).to have_received(:name=)
          .with(user.name)
        expect(discourse_sso).to have_received(:username=)
          .with(user.github_username)
        expect(discourse_sso).to have_received(:external_id=)
          .with(user.id)
        expect(discourse_sso).to have_received(:sso_secret=)
          .with(ENV.fetch("DISCOURSE_SSO_SECRET"))
      end
    end

    context "when not logged in" do
      it "denies access" do
        get :new, params: {sso: "ssohash", sig: "sig"}

        should deny_access
      end
    end

    def discourse_sso_stub
      sso = double("SingleSignOn")
      [:email, :name, :username, :external_id, :sso_secret].each do |accessor|
        allow(sso).to receive(:"#{accessor}=")
      end
      allow(sso).to receive(:to_url).and_return("https://forum.example.com")
      sso
    end
  end
end
