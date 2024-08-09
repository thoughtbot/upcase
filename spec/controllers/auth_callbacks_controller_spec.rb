require "rails_helper"

describe AuthCallbacksController do
  context "#create" do
    it "redirects to the practice path without an auth origin" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      request.env["omniauth.origin"] = nil

      get :create, params: {provider: "github"}

      should redirect_to(practice_url)
    end

    it "does not redirect to a page outside of the thoughtbot domain" do
      # This prevents attackers from redirecting our users to lookalike
      # phishing websites
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      request.env["omniauth.origin"] = "//google.com"

      get :create, params: {provider: "github"}

      should redirect_to(practice_url)
    end
  end
end
