require "rails_helper"

describe ForumSessionsController do
  include StubCurrentUserHelper

  describe "#new" do
    context "when logged in as a subscriber" do
      it "properly redirects to the forum" do
        user = create(:subscriber)
        stub_current_user_with(user)
        discourse_sso = discourse_sso_stub
        DiscourseSignOn.stubs(:parse).returns(discourse_sso)

        get :new, sso: "ssohash", sig: "sig"

        expect(DiscourseSignOn).to have_received(:parse).with(
          "sig=sig&sso=ssohash",
          ENV["DISCOURSE_SSO_SECRET"]
        )
        expect(response).to redirect_to(
          discourse_sso.to_url(
            Forum.sso_url
          )
        )
        expect(discourse_sso).to have_received(:email=).with(user.email)
        expect(discourse_sso).to have_received(:name=).with(user.name)
        expect(discourse_sso).to have_received(:username=).with(
          user.github_username
        )
        expect(discourse_sso).to have_received(:external_id=).with(user.id)
        expect(discourse_sso).to have_received(:sso_secret=).with(
          ENV["DISCOURSE_SSO_SECRET"]
        )
      end
    end

    context "when logged in as a subscriber without forum access" do
      it "redirects to new_subscription_url" do
        user = create(:basic_subscriber)
        stub_current_user_with(user)

        get :new, sso: "ssohash", sig: "sig"

        should deny_access(
          redirect: new_subscription_url,
          flash: I18n.t(
            "products.show.subscribe_cta",
            offering_type: "forum",
            subscription_name: I18n.t("shared.upcase")
          )
        )
      end
    end

    context "when logged in but not subscribed" do
      it "redirects to new_subscription_url" do
        user = build_stubbed(:user)
        stub_current_user_with(user)

        get :new, sso: "ssohash", sig: "sig"

        should deny_access(
          redirect: new_subscription_url,
          flash: I18n.t(
            "products.show.subscribe_cta",
            offering_type: "forum",
            subscription_name: I18n.t("shared.upcase")
          )
        )
      end
    end

    context "when not logged in" do
      it "denies access" do
        get :new, sso: "ssohash", sig: "sig"

        should deny_access
      end
    end

    def discourse_sso_stub
      sso = stub
      [:email, :name, :username, :external_id, :sso_secret].each do |accessor|
        sso.stubs(:"#{accessor}=")
      end
      sso.stubs(:to_url).returns("https://forum.example.com")
      sso
    end
  end
end
