require "rails_helper"

include StubCurrentUserHelper

describe CheckoutsController do
  describe "#new" do
    context "when purchasing an individual plan as an active subscriber" do
      it "redirects to plan editing" do
        user = create(:subscriber)
        stub_current_user_with(user)

        get :new, plan: user.subscription.plan

        expect(response).to redirect_to edit_subscription_path
      end
    end

    context "with a team plan when there is more than one" do
      it "uses the requested plan" do
        user = create(:user)
        stub_current_user_with(user)

        create(:plan, :team, sku: "sku1")
        desired_plan = create(:plan, :team, sku: "sku2")

        get :new, plan: desired_plan

        expect(assigns(:checkout).plan).to eq desired_plan
      end
    end

    context "with a plan that is not found" do
      it "redirects to the default plan" do
        popular = build_stubbed(:plan)
        Plan.stubs(:popular).returns(popular)

        get :new, plan: "notfound"

        expect(response).to redirect_to new_checkout_path(plan: popular)
        expect(flash[:notice]).to eq I18n.t("checkout.flashes.plan_not_found")
      end
    end
  end

  describe "#create" do
    it "creates and saves a stripe customer and charges it for the product" do
      stub_current_user_with create(:user)
      plan = create(:plan)
      stripe_token = "token"

      post :create, checkout: customer_params(stripe_token), plan: plan

      expect(FakeStripe.customer_plan_id).to eq plan.sku
    end

    it "sets flash[:purchase_amount]" do
      stub_current_user_with create(:user)
      plan = create(:plan)

      post :create, checkout: customer_params, plan: plan

      expect(flash[:purchase_amount]).to eq plan.individual_price
    end
  end

  def customer_params(token = "stripe token")
    {
      name: "User",
      email: "test@example.com",
      github_username: 'test',
      stripe_token: token,
    }
  end
end
