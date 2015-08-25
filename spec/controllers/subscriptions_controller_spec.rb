require "rails_helper"

describe SubscriptionsController do
  context "update" do
    it_behaves_like "must be subscription owner" do
      def perform_request
        plan = create(:plan)

        post :update, plan_id: plan
      end

      def authorize
        redirect_to(my_account_path)
      end
    end
  end

  context "edit" do
    it_behaves_like "must be subscription owner" do
      def perform_request
        get :edit
      end

      def authorize
        respond_with(:success)
      end
    end
  end

  describe "#new" do
    include VanityHelpers

    context "when the A/B test selects the existing checkout flow" do
      it "renders the existing landing page" do
        stub_ab_test_result(:checkout_flow, :existing)

        get :new

        expect(response).to render_template(:new)
      end
    end

    context "when the A/B test selects the new checkout flow" do
      it "redirects to the new landing page path" do
        stub_ab_test_result(:checkout_flow, :new)

        get :new

        expect(response).to redirect_to(page_path("landing"))
      end
    end
  end
end
