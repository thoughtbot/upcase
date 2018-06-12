require "rails_helper"

include StubCurrentUserHelper

describe CheckoutsController do
  describe "#new" do
    context "when purchasing an individual plan as an active subscriber" do
      it "redirects to the root path" do
        user = create(:subscriber)
        stub_current_user_with(user)

        get :new, params: { plan: stub_valid_sku }

        expect(response).to redirect_to root_path
      end
    end

    context "with a team plan when there is more than one" do
      it "uses the requested plan" do
        user = create(:user)
        stub_current_user_with(user)

        stub_plan_by_sku(:team, sku: "sku1")
        desired_plan = stub_plan_by_sku(:team, sku: "sku2")

        get :new, params: { plan: desired_plan }

        expect(assigns(:checkout).plan).to eq desired_plan
      end
    end

    context "with a plan that is not found" do
      it "redirects to the default plan" do
        professional = build_stubbed(:plan)
        allow(Plan).to receive(:professional).and_return(professional)

        get :new, params: { plan: "notfound" }

        expect(response).to redirect_to new_checkout_path(plan: professional)
        expect(flash[:notice]).to eq I18n.t("checkout.flashes.plan_not_found")
      end
    end

    context "with a valid stripe_coupon in the session" do
      it "should set a stripe_coupon_id on the checkout" do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        coupon = stub_coupon(valid: true)
        session[:coupon] = coupon.code

        get :new, params: { plan: stub_valid_sku }

        expect(assigns(:checkout).stripe_coupon_id).to eq coupon.code
      end
    end

    context "with an invalid stripe_coupon in the session" do
      it "renders an error and removes the coupon" do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        coupon_code = stub_coupon(valid: false).code
        session[:coupon] = coupon_code
        plan_sku = stub_valid_sku

        get :new, params: { plan: plan_sku }

        expect(session[:coupon]).to be_nil
        expect(controller).to redirect_to new_checkout_path plan_sku
        expect(controller).to set_flash.to(
          I18n.t("checkout.flashes.invalid_coupon", code: coupon_code),
        )
      end
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
      github_username: 'test',
      stripe_token: token
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

  def stub_coupon(valid:)
    create(:coupon).tap do |coupon|
      allow(Coupon).to receive(:new).with(coupon.code).and_return(coupon)
      allow(coupon).to receive(:valid?).and_return(valid)
    end
  end
end
