require "spec_helper"

include StubCurrentUserHelper

describe CheckoutsController do
  describe "#new when purchasing a plan as an active subscriber" do
    context "when purchasing an individual plan" do
      it "redirects to plan editing" do
        user = create(:subscriber)
        stub_current_user_with(user)

        get :new, individual_plan_id: user.subscription.plan

        expect(response).to redirect_to edit_plan_path
      end
    end
  end

  describe "#new with a team plan when there is more than one" do
    it "uses the requested plan" do
      user = create(:user)
      stub_current_user_with(user)

      create(:team_plan, sku: "sku1")
      desired_plan = create(:team_plan, sku: "sku2")

      get :new, teams_team_plan_id: desired_plan.sku

      expect(assigns(:checkout).subscribeable).to eq desired_plan
    end
  end

  describe "#create" do
    it "creates and saves a stripe customer and charges it for the product" do
      user = create(:user)
      stub_current_user_with(user)
      plan = create(:individual_plan)
      stripe_token = "token"

      post(
        :create,
        checkout: customer_params(stripe_token),
        plan_id: plan.to_param
      )

      FakeStripe.should(
        have_charged(1500).to("test@example.com").with_token(stripe_token)
      )
    end
  end

  def customer_params(token = "stripe token")
    {
      name: "User",
      email: "test@example.com",
      variant: "individual",
      stripe_token: token,
      payment_method: "stripe"
    }
  end
end
