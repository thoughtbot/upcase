require "rails_helper"

describe ForumSessionsController do
  include StubCurrentUserHelper

  describe "#new" do
    context "when logged in as a subscriber" do
      it "properly redirects to the forum" do
        user = create(:subscriber)
        stub_current_user_with(user)
        discourse_sso = discourse_sso_stub
        allow(DiscourseSignOn).to receive(:parse).and_return(discourse_sso)

        get :new, params: { sso: "ssohash", sig: "sig" }

        expect(DiscourseSignOn).to have_received(:parse).
          with(
            "sig=sig&sso=ssohash",
            ENV.fetch("DISCOURSE_SSO_SECRET"),
          )
        expect(response).to redirect_to(
          discourse_sso.to_url(
            Forum.sso_url
          )
        )
        expect(discourse_sso).to have_received(:email=).
          with(user.email)
        expect(discourse_sso).to have_received(:name=).
          with(user.name)
        expect(discourse_sso).to have_received(:username=).
          with(user.github_username)
        expect(discourse_sso).to have_received(:external_id=).
          with(user.id)
        expect(discourse_sso).to have_received(:sso_secret=).
          with(ENV.fetch("DISCOURSE_SSO_SECRET"))
        expect(analytics).to have_tracked("Logged into Forum").
          for_user(user)
      end
    end

    context "when logged in but not subscribed" do
      it "redirects to the landing page" do
        user = build_stubbed(:user)
        stub_current_user_with(user)

        get :new, params: { sso: "ssohash", sig: "sig" }

        should deny_access(
          redirect: root_path,
          flash: I18n.t(
            "products.subscribe_cta",
            offering_type: "forum",
            subscription_name: I18n.t("shared.upcase")
          )
        )
      end
    end

    context "when not logged in" do
      it "denies access" do
        get :new, params: { sso: "ssohash", sig: "sig" }

        should deny_access
      end
    end

    def discourse_sso_stub
      sso = double("DiscourseSignOn")
      [:email, :name, :username, :external_id, :sso_secret].each do |accessor|
        allow(sso).to receive(:"#{accessor}=")
      end
      allow(sso).to receive(:to_url).and_return("https://forum.example.com")
      sso
    end
  end
end
