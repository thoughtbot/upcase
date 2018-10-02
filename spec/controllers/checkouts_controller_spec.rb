require "rails_helper"

describe CheckoutsController do
  include StubCurrentUserHelper

  describe "#new" do
    it "redirects to the sign_in path" do
      get :new, params: { plan: stub_valid_sku }

      expect(response).to redirect_to sign_in_path
    end
  end

  describe "#create" do
    it "creates and saves a stripe customer and charges it for the product" do
      stub_current_user_with create(:user)
      plan = create(:plan)
      stripe_token = "token"

      post :create, params: {
        checkout: customer_params(stripe_token),
        plan: plan,
      }

      expect(FakeStripe.customer_plan_id).to eq plan.sku
    end

    it "sets flash[:purchase_amount]" do
      stub_current_user_with create(:user)
      plan = create(:plan)

      post :create, params: { checkout: customer_params, plan: plan }

      expect(flash[:purchase_amount]).to eq plan.price_in_dollars
    end

    it "removes any coupon from the session" do
      create(:coupon, code: "5OFF")
      session[:coupon] = "5OFF"
      stub_current_user_with create(:user)
      plan = create(:plan)
      stripe_token = "token"

      params_with_coupon = customer_params(stripe_token).
        merge(stripe_coupon_id: "5OFF")

      post(
        :create,
        params: {
          checkout: params_with_coupon,
          plan: plan,
        },
      )

      expect(session[:coupon]).to be_nil
    end

    context "with customer acquisition channel saved in session" do
      it "records channel as utm_source" do
        session[:campaign_params] = { utm_source: "adwords" }
        user = create(:user, utm_source: nil)
        stub_current_user_with user
        plan = create(:plan)
        stripe_token = "token"

        post(
          :create,
          params: {
            checkout: customer_params(stripe_token),
            plan: plan,
          },
        )

        expect(user.reload.utm_source).to eq "adwords"
      end
    end
  end

  def customer_params(token = "stripe token")
    {
      name: "User",
      email: "test@example.com",
      github_username: "test",
      stripe_token: token,
    }
  end

  def stub_valid_sku
    stub_plan_by_sku.sku
  end

  def stub_plan_by_sku(*attributes)
    build_stubbed(:plan, *attributes).tap do |plan|
      allow(Plan).to receive(:find_by).with(sku: plan.sku).and_return(plan)
    end
  end
end
