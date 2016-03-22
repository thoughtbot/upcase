require "rails_helper"

describe AuthenticatedOnCheckoutsController do
  context "#show" do
    it "records that the user authenticated on checkout" do
      get :show, plan: create(:plan)

      expect(session[:authenticated_on_checkout]).to eq(true)
    end

    it "redirects to github auth with a proper origin param" do
      plan = create(:plan)
      plan_checkout_origin = { "origin" => new_checkout_path(plan: plan) }

      get :show, plan: plan.sku

      expect(response).to redirect_to(%r{/auth/github})
      expect(response_query_params).to include(plan_checkout_origin)
    end
  end

  def response_query_params
    parsed_uri = URI.parse(response.location)
    unescaped_query_params = URI.unescape(parsed_uri.query || "")
    Hash[unescaped_query_params.split("&").map { |q| q.split("=") }]
  end
end
