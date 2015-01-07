require "rails_helper"

describe Subscriber::CancellationsController do
  context "create" do
    it_behaves_like "must be subscription owner" do
      def perform_request
        post :create, cancellation: { reason: "reason" }
      end

      def authorize
        redirect_to(my_account_path)
      end
    end
  end

  context "new" do
    it_behaves_like "must be subscription owner" do
      def perform_request
        get :new
      end

      def authorize
        respond_with(:success)
      end
    end
  end
end
