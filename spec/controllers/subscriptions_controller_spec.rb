require "rails_helper"

describe SubscriptionsController do
  context "update" do
    it_behaves_like "must be subscription owner" do
      def perform_request
        plan = create(:individual_plan)

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
end
